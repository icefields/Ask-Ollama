# Ask Ollama
```
   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄ 
  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌
  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌
   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀ 
                                                                 
```
### Example Usage
```
local ollama = require("ollama-req")

local answer = ollama.askOllama("llama3.2", "tell me about calico cats", "192.168.6.66")

print("Model: " .. answer.model)
print("Created At: " .. answer.created_at)
print("Response: " .. answer.response)
```

### Command line usage
```
# -m    model name, ie. "llama3.2".
# -s    server, defaults to localhost, remember to init ollama with OLLAMA_HOST=0.0.0.0:11434 to enable external servers.
# -q    query, mandatory parameter.

lua ollama-req.lua -q "tell me about calico cats" -s 192.168.6.66  -m llama3.2
```
