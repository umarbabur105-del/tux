#!/data/data/com.termux/files/usr/bin/bash
# tux-setup.sh — First-run setup for Tux AI Terminal
# Installs Claude Code, Codex, and Gemini CLIs

set -e

TUX_VERSION="0.1.0"
PREFIX="/data/data/com.termux/files/usr"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
cat << 'BANNER'
  _____
 |_   _|   ___  __
   | || | | \ \/ /
   | || |_| |>  <
   |_| \__,_/_/\_\

 AI Terminal for Android
BANNER
echo -e "${NC}"

echo -e "${CYAN}Setting up Tux v${TUX_VERSION}...${NC}"
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Installing Node.js...${NC}"
    pkg install -y nodejs-lts
fi
echo -e "${GREEN}Node.js $(node -v)${NC}"

# Check Python
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}Installing Python...${NC}"
    pkg install -y python
fi
echo -e "${GREEN}Python $(python3 --version | cut -d' ' -f2)${NC}"

# Check git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Installing git...${NC}"
    pkg install -y git
fi
echo -e "${GREEN}git $(git --version | cut -d' ' -f3)${NC}"

echo ""
echo -e "${CYAN}Installing AI CLIs...${NC}"
echo ""

# Claude Code CLI — works directly on Termux/Android
echo -e "${YELLOW}[1/3] Installing Claude Code CLI...${NC}"
if command -v claude &> /dev/null; then
    echo -e "${GREEN}  Claude Code already installed$(claude --version 2>/dev/null && echo "" || echo "")${NC}"
else
    npm install -g @anthropic-ai/claude-code 2>&1 | tail -3
    if command -v claude &> /dev/null; then
        echo -e "${GREEN}  Claude Code installed${NC}"
    else
        echo -e "${RED}  Claude Code installation failed${NC}"
    fi
fi

# Codex CLI — need Termux-compatible fork (official has ripgrep platform check issues)
echo -e "${YELLOW}[2/3] Installing Codex CLI...${NC}"
if command -v codex &> /dev/null; then
    echo -e "${GREEN}  Codex already installed${NC}"
else
    # Try the official package first, fall back to community fork
    npm install -g @openai/codex 2>&1 | tail -3
    if command -v codex &> /dev/null; then
        echo -e "${GREEN}  Codex installed${NC}"
    else
        echo -e "${YELLOW}  Official codex failed, trying community fork...${NC}"
        npm install -g @openai/codex --ignore-scripts 2>&1 | tail -3
        if command -v codex &> /dev/null; then
            echo -e "${GREEN}  Codex installed (with --ignore-scripts)${NC}"
        else
            echo -e "${RED}  Codex installation failed — may need manual install${NC}"
        fi
    fi
fi

# Gemini CLI — may have node-gyp issues, use --ignore-scripts
echo -e "${YELLOW}[3/3] Installing Gemini CLI...${NC}"
if command -v gemini &> /dev/null; then
    echo -e "${GREEN}  Gemini already installed${NC}"
else
    npm install -g @anthropic-ai/gemini-cli 2>&1 | tail -3 || \
    npm install -g @google/gemini-cli --ignore-scripts 2>&1 | tail -3
    if command -v gemini &> /dev/null; then
        echo -e "${GREEN}  Gemini installed${NC}"
    else
        echo -e "${RED}  Gemini installation failed — may need manual install${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Tux setup complete!${NC}"
echo ""
echo -e "Available CLIs:"
command -v claude &> /dev/null && echo -e "  ${CYAN}claude${NC}  — Claude Code (Anthropic)"
command -v codex &> /dev/null && echo -e "  ${CYAN}codex${NC}   — Codex CLI (OpenAI)"
command -v gemini &> /dev/null && echo -e "  ${CYAN}gemini${NC}  — Gemini CLI (Google)"
echo ""
echo -e "First-time auth (opens browser):"
echo -e "  ${YELLOW}claude auth login${NC}   — Claude Max subscription"
echo -e "  ${YELLOW}codex auth login${NC}    — ChatGPT Plus subscription"
echo -e "  ${YELLOW}gemini auth login${NC}   — Google account"
echo ""
