"""
requirements.txt:
streamlit
pandas
numpy
scikit-learn
nltk
matplotlib
altair
seaborn
"""

import os
import re
import streamlit as st
import pandas as pd
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    classification_report, confusion_matrix,
    accuracy_score, precision_score, recall_score, f1_score
)
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.feature_extraction.text import CountVectorizer
import nltk
import altair as alt
import matplotlib.pyplot as plt
import seaborn as sns

# ─── Streamlit Page & Title ───────────────────────────────────────────────────
st.set_page_config(page_title="Cosmic ML Dashboard", page_icon="🌌", layout="wide")
st.title("🌠 Cosmic ML Dashboard")
st.write("Explore synthetic **Pass/Fail** prediction and **Sentiment Analysis** in a single app.")
st.write("> Enjoy the cosmic-themed UI and interactive plots!")

# ─── COSMIC THEME CSS (Animated Starfield) ────────────────────────────────────
st.markdown(
    """
    <style>
    @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&display=swap');

    body, .viewerBadge_container__1QSob {
      background: url('https://media.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif')
                  center center / cover no-repeat fixed;
      font-family: 'Orbitron', sans-serif;
      color: #e0e0e0;
    }
    .appview-container .main {
      background: rgba(0,0,0,0.7);
      padding: 2rem;
      border-radius: 12px;
    }
    h1, h2, h3, .stMarkdown h1, .stMarkdown h2 {
      text-shadow: 0 0 8px rgba(102,252,241,.8), 0 0 16px rgba(102,252,241,.6);
      color: #66FCF1;
    }
    .stButton>button {
      background-color: rgba(10,25,47,0.8) !important;
      color: #66FCF1 !important;
      border: 2px solid #66FCF1 !important;
      border-radius: 12px !important;
      padding: 0.6rem 1.2rem !important;
      font-weight: bold !important;
      transition: all 0.3s ease;
    }
    .stButton>button:hover {
      background-color: #66FCF1 !important;
      color: #0b0c10 !important;
      box-shadow: 0 0 12px #66FCF1;
      transform: translateY(-2px);
    }
    .stTabs [role="tablist"] button {
      background: rgba(10,25,47,0.6);
      color: #e0e0e0;
      font-weight: bold;
    }
    .stTabs [role="tablist"] button[aria-selected="true"] {
      background: #112;
      color: #66FCF1;
      box-shadow: inset 0 -3px 0 #66FCF1;
    }
    .stDataFrame, .st-df {
      background: rgba(0, 0, 0, 0.7) !important;
      border-radius: 8px;
    }
    .stPlotlyChart, .stAltairChart {
      background: rgba(0, 0, 0, 0.7) !important;
      padding: 1rem;
      border-radius: 8px;
    }
    .css-1d391kg {
      background: rgba(0,0,0,0.8);
      color: #e0e0e0;
      font-family: 'Orbitron', sans-serif;
    }
    </style>
    """,
    unsafe_allow_html=True
)

# ─── NLTK STOPWORDS SETUP ───────────────────────────────────────────────────────
@st.cache_resource
def load_stopwords():
    nltk.download('stopwords', quiet=True)
    from nltk.corpus import stopwords
    return set(stopwords.words('english'))

stop_words = load_stopwords()
from nltk.stem import PorterStemmer
stemmer = PorterStemmer()

# ─── DATA GENERATION ────────────────────────────────────────────────────────────
@st.cache_data
def generate_passfail_data(n_samples=200):
    np.random.seed(42)
    study = np.random.uniform(0, 20, n_samples)
    attendance = np.random.uniform(50, 100, n_samples)
    noise = np.random.normal(0, 1, n_samples)
    score = 0.3 * study + 0.02 * attendance + noise
    passed = (score > 5).astype(int)
    return pd.DataFrame({
        'study_hours': study,
        'attendance_pct': attendance,
        'pass': passed
    })

@st.cache_data
def generate_sentiment_data(n_samples=100):
    positive = [
        "I love this product", "Amazing experience", "Absolutely fantastic service",
        "Very satisfied", "Best purchase ever", "So happy with it",
        "Exceeded expectations", "Truly wonderful", "Highly recommend this", "Superb quality"
    ]
    negative = [
        "I hate this", "Terrible experience", "Absolutely awful service",
        "Very disappointed", "Worst purchase ever", "Made me so angry",
        "Fell short of expectations", "Truly horrible", "Do not recommend", "Poor quality"
    ]
    reviews, sentiments = [], []
    for _ in range(n_samples):
        if np.random.rand() < 0.5:
            reviews.append(np.random.choice(positive)); sentiments.append(1)
        else:
            reviews.append(np.random.choice(negative)); sentiments.append(0)
    return pd.DataFrame({'review_text': reviews, 'sentiment': sentiments})

# ─── TEXT PREPROCESSING ────────────────────────────────────────────────────────
def preprocess_text(text: str) -> str:
    text = text.lower()
    tokens = re.findall(r'\b[a-z]+\b', text)
    filtered = [stemmer.stem(w) for w in tokens if w not in stop_words]
    return " ".join(filtered)

# ─── LOAD OR GENERATE DATA ─────────────────────────────────────────────────────
df_passfail = generate_passfail_data()
df_sentiment = generate_sentiment_data()

# ─── DOWNLOAD BUTTONS ──────────────────────────────────────────────────────────
st.download_button(
    "📥 Download Pass/Fail Dataset (CSV)",
    data=df_passfail.to_csv(index=False).encode('utf-8'),
    file_name='pass_fail_data.csv',
    mime='text/csv'
)
st.download_button(
    "📥 Download Sentiment Dataset (CSV)",
    data=df_sentiment.to_csv(index=False).encode('utf-8'),
    file_name='sentiment_data.csv',
    mime='text/csv'
)

# ─── TABS FOR TASKS ────────────────────────────────────────────────────────────
tab1, tab2 = st.tabs(["Task 1: Pass/Fail Prediction", "Task 2: Sentiment Analysis"])

# ─── TASK 1: PASS/FAIL PREDICTION ──────────────────────────────────────────────
with tab1:
    st.header("Pass/Fail Prediction")
    st.subheader("📊 Data Preview")
    st.dataframe(df_passfail.head())

    X = df_passfail[['study_hours', 'attendance_pct']]
    y = df_passfail['pass']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1)

    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    clf = LogisticRegression(solver='liblinear')
    clf.fit(X_train_scaled, y_train)
    y_pred = clf.predict(X_test_scaled)

    st.subheader("🔍 Feature Scatter Plot")
    chart = alt.Chart(df_passfail).mark_circle(size=60).encode(
        x='study_hours', y='attendance_pct',
        color=alt.Color('pass:N', scale=alt.Scale(domain=[0,1], range=['#ff4136','#2ecc40'])),
        tooltip=['study_hours','attendance_pct','pass']
    ).properties(width=600, height=400)
    st.altair_chart(chart, use_container_width=True)

    st.subheader("📈 Evaluation Metrics")
    st.write(f"- **Accuracy:**  {accuracy_score(y_test, y_pred):.2f}")
    st.write(f"- **Precision:** {precision_score(y_test, y_pred):.2f}")
    st.write(f"- **Recall:**    {recall_score(y_test, y_pred):.2f}")
    st.write(f"- **F1 Score:**  {f1_score(y_test, y_pred):.2f}")

    st.subheader("📌 Confusion Matrix")
    cm = confusion_matrix(y_test, y_pred)
    fig1, ax1 = plt.subplots()
    sns.heatmap(cm, annot=True, fmt='d', cmap="Blues", ax=ax1)
    ax1.set_title("Pass/Fail Confusion Matrix")
    ax1.set_xlabel("Predicted"); ax1.set_ylabel("Actual")
    st.pyplot(fig1)

# ─── TASK 2: SENTIMENT ANALYSIS ───────────────────────────────────────────────
with tab2:
    st.header("Sentiment Analysis")
    st.subheader("📊 Data Preview")
    st.dataframe(df_sentiment.head())

    df_sentiment['clean_text'] = df_sentiment['review_text'].apply(preprocess_text)
    vectorizer = CountVectorizer(max_features=5000, ngram_range=(1,2))
    X_text = vectorizer.fit_transform(df_sentiment['clean_text'])
    y_text = df_sentiment['sentiment']
    X_train2, X_test2, y_train2, y_test2 = train_test_split(
        X_text, y_text, test_size=0.3, random_state=1)

    clf_text = LogisticRegression(solver='liblinear')
    clf_text.fit(X_train2, y_train2)
    y_pred2 = clf_text.predict(X_test2)

    st.subheader("📈 Evaluation Metrics")
    st.write(f"- **Accuracy:**  {accuracy_score(y_test2, y_pred2):.2f}")
    st.write(f"- **Precision:** {precision_score(y_test2, y_pred2):.2f}")
    st.write(f"- **Recall:**    {recall_score(y_test2, y_pred2):.2f}")
    st.write(f"- **F1 Score:**  {f1_score(y_test2, y_pred2):.2f}")

    st.subheader("📌 Confusion Matrix")
    cm2 = confusion_matrix(y_test2, y_pred2)
    fig2, ax2 = plt.subplots()
    sns.heatmap(cm2, annot=True, fmt='d', cmap="Oranges", ax=ax2)
    ax2.set_title("Sentiment Confusion Matrix")
    ax2.set_xlabel("Predicted"); ax2.set_ylabel("Actual")
    st.pyplot(fig2)

    st.subheader("📝 Classification Report")
    report = classification_report(y_test2, y_pred2, target_names=["Negative","Positive"])
    st.text(report)
