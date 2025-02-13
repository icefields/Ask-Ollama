### Example Usage
```
local ollama = require("ollama-req")

local answer = ollama.askOllama("llama3.2", "tell me about calico cats", "192.168.6.66")

print("Model: " .. answer.model)
print("Created At: " .. answer.created_at)
print("Response: " .. answer.response)
```
