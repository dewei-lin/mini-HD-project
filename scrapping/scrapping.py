from pdfminer.high_level import extract_text
import re
from collections import Counter
import matplotlib.pyplot as plt
from wordcloud import WordCloud
import os

# Function to clean and extract keywords
def clean_and_extract_keywords(keywords_section):
    keywords_section = re.split(r"(Introduction|Abstract|Contents|Content|How to cite|university|\d+)", 
                                 keywords_section, 
                                 flags=re.IGNORECASE)[0]
    keywords_section = re.sub(r"-\s", "", keywords_section)
    keywords_section = re.sub(r"\s+", " ", keywords_section).strip()
    keywords = re.split(r",|;", keywords_section)
    cleaned_keywords = [
        kw.strip() for kw in keywords
        if len(kw.split()) <= 3
    ]
    return "; ".join(cleaned_keywords).strip()

# Function to extract keywords from a PDF
def extract_keywords_from_pdf(pdf_path):
    try:
        text = extract_text(pdf_path)
        match = re.search(r"(Key Words|Keywords|Key words|KEYWORDS):", text, re.IGNORECASE)
        if match:
            start = match.end()
            keywords_section = text[start:].strip()
            keywords_section = re.split(r"(university)", keywords_section, flags=re.IGNORECASE)[0]
            return clean_and_extract_keywords(keywords_section)
        return "Keywords not found."
    except Exception as e:
        return f"Error processing {pdf_path}: {e}"

# Function to process multiple PDFs and extract keywords
def process_multiple_pdfs(pdf_folder):
    results = {}
    for file_name in os.listdir(pdf_folder):
        if file_name.endswith(".pdf"):
            pdf_path = os.path.join(pdf_folder, file_name)
            keywords = extract_keywords_from_pdf(pdf_path)
            results[file_name] = keywords if keywords.strip() else "Keywords not found."
    return results

# Function to generate a bubble-like visualization
def create_bubble_visualization(keyword_counts, output_path):
    word_freq = dict(keyword_counts)
    wordcloud = WordCloud(
        background_color="white",
        width=800,
        height=600,
        colormap="viridis",
        prefer_horizontal=1.0
    ).generate_from_frequencies(word_freq)
    
    plt.figure(figsize=(10, 6))
    plt.imshow(wordcloud, interpolation="bilinear")
    plt.axis("off")
    plt.savefig(output_path, bbox_inches="tight")
    plt.close()

if __name__ == "__main__":
    # Set folder paths
    pdf_folder = "./scrapping"
    plot_folder = "./plot"
    
    # Ensure the plot folder exists
    os.makedirs(plot_folder, exist_ok=True)
    
    # Output plot path
    output_image = os.path.join(plot_folder, "keyword_plot.png")

    # Extract keywords
    extracted_keywords = process_multiple_pdfs(pdf_folder)
    filtered_keywords = {paper: keywords for paper, keywords in extracted_keywords.items() if "Keywords not found." not in keywords}

    # Extract and split keywords into individual terms
    all_keywords = []
    for keywords in filtered_keywords.values():
        all_keywords.extend([kw.strip() for kw in keywords.split(";") if kw.strip()])

    # Count keyword frequencies
    keyword_counts = Counter(all_keywords)

    # Generate and save the bubble-like visualization
    create_bubble_visualization(keyword_counts, output_image)
