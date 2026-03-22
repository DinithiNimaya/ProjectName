from io import BytesIO
import fitz
from docx import Document


def extract_resume_text(filename: str, file_bytes: bytes) -> str:
    name = (filename or "").lower()

    if name.endswith(".pdf"):
        parts = []
        with fitz.open(stream=file_bytes, filetype="pdf") as doc:
            for page in doc:
                parts.append(page.get_text("text"))
        return "\n".join(parts).strip()

    if name.endswith(".docx"):
        doc = Document(BytesIO(file_bytes))
        parts = [p.text for p in doc.paragraphs if p.text]
        return "\n".join(parts).strip()

    raise ValueError("Unsupported file type. Only PDF and DOCX are allowed.")