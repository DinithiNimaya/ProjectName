from io import BytesIO
import fitz  # PyMuPDF
from docx import Document
from app.utils.text_cleaning import clean_text

def extract_resume_text(filename: str, file_bytes: bytes) -> str:
    name = (filename or "").lower()

    if name.endswith(".pdf"):
        parts: list[str] = []
        with fitz.open(stream=file_bytes, filetype="pdf") as doc:
            for page in doc:
                parts.append(page.get_text("text"))
        return clean_text("\n".join(parts))

    if name.endswith(".docx"):
        doc = Document(BytesIO(file_bytes))
        parts = [p.text for p in doc.paragraphs if p.text]
        return clean_text("\n".join(parts))

    raise ValueError("Unsupported file type. Only PDF and DOCX are allowed.")