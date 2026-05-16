"""
LearnHub AI Tutor — backend proxy.

The Flutter app talks to ONE endpoint here:
    POST /api/ai/chat   { "session_id": "...", "message": "..." }

We forward the message to Claude Sonnet 4.5 (via the Emergent LLM key) and
return the AI's reply.  The key never leaves the server, so it stays safe.
"""

import os
from typing import List, Dict

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from emergentintegrations.llm.chat import LlmChat, UserMessage

# 1. Load secrets from .env (EMERGENT_LLM_KEY, MONGO_URL, ...)
load_dotenv()

EMERGENT_LLM_KEY = os.environ.get("EMERGENT_LLM_KEY")

# System prompt: tells Claude *who it is* for every chat in this app.
TUTOR_SYSTEM_PROMPT = (
    "You are an expert learning tutor inside the LearnHub e-learning app. "
    "Your students are learning programming, software engineering, and tech "
    "concepts. Explain things clearly, use simple analogies, give short code "
    "examples when relevant, and be encouraging. If a question is unrelated "
    "to learning/tech, gently steer back to studies. Keep answers concise."
)

# Cache one LlmChat per session_id so multi-turn history is preserved.
_chat_sessions: Dict[str, LlmChat] = {}


app = FastAPI(title="LearnHub AI Tutor API")

# Allow the Flutter app (any origin during dev) to call us.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# ---------- Request / response schemas ----------
class ChatRequest(BaseModel):
    session_id: str
    message: str


class ChatResponse(BaseModel):
    reply: str


# ---------- Routes ----------
@app.get("/api/health")
async def health():
    return {"status": "ok"}


@app.post("/api/ai/chat", response_model=ChatResponse)
async def ai_chat(req: ChatRequest):
    if not EMERGENT_LLM_KEY:
        raise HTTPException(status_code=500, detail="EMERGENT_LLM_KEY missing")

    # Reuse the chat for this session, or create a new one.
    chat = _chat_sessions.get(req.session_id)
    if chat is None:
        chat = LlmChat(
            api_key=EMERGENT_LLM_KEY,
            session_id=req.session_id,
            system_message=TUTOR_SYSTEM_PROMPT,
        ).with_model("anthropic", "claude-sonnet-4-5-20250929")
        _chat_sessions[req.session_id] = chat

    try:
        reply = await chat.send_message(UserMessage(text=req.message))
        return ChatResponse(reply=reply)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI error: {e}")


@app.delete("/api/ai/chat/{session_id}")
async def reset_chat(session_id: str):
    """Clear chat history for a session (used by the 'Clear' button)."""
    _chat_sessions.pop(session_id, None)
    return {"cleared": True}
