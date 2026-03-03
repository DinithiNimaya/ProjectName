from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    ENV: str = "dev"
    APP_NAME: str = "AUSkillPath API"

    OPENAI_API_KEY: str = ""
    OPENAI_MODEL: str = "gpt-5"

    ADZUNA_APP_ID: str = ""
    ADZUNA_APP_KEY: str = ""
    ADZUNA_COUNTRY: str = "au"

settings = Settings()