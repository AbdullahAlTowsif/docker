# 🧙 The Magic Behind `docker build` (Layers Explained)

Every instruction in a `Dockerfile` creates a **new layer** — and each layer is really just a small, automated repeat of the *"temporary container → commit → remove"* cycle.

---

## 🧾 Example Dockerfile

```dockerfile
FROM ubuntu:24.04
RUN apt update
RUN apt install -y golang
WORKDIR /app
COPY ./server.go ./server.go
CMD ["go", "run", "server.go"]
```

Let's break down what Docker does **internally**, instruction by instruction.

---

## 🏗️ Layer-by-Layer Breakdown

### **Step 1 — `FROM ubuntu:24.04`** → `Layer 0`

- Checks the local cache first
- If not found, pulls the image from Docker Hub
- Loads the image

> ✅ This becomes **Layer 0** — the base layer everything else builds on.

---

### **Step 2 — `RUN apt update`** → `Layer 1`

1. Create a **temporary container** (spun up *from* the Layer 0 image)
2. Run `apt update` inside it
3. **Commit** the container → freezes its current state as a new image
4. **Remove** the temporary container

> ✅ Committing creates **Layer 1**.

---

### **Step 3 — `RUN apt install -y golang`** → `Layer 2`

1. Create a **temporary container** (from the Layer 1 image)
2. Run `apt install -y golang` inside it
3. Commit the container
4. Remove the temporary container

> ✅ New image created: **Layer 2**

---

### **Step 4 — `WORKDIR /app`** → `Layer 3`

1. Create a **temporary container** (from the Layer 2 image)
2. Set the working directory to `/app`
3. Commit the container
4. Remove the temporary container

> ✅ New image created: **Layer 3**

---

### **Step 5 — `COPY ./server.go ./server.go`** → `Layer 4` (Final)

1. Create a **temporary container** (from the Layer 3 image)
2. Copy `server.go` into the container
3. Commit the container
4. Remove the temporary container

> ✅ New image created: **Layer 4** — and this is where the `CMD ["go", "run", "server.go"]` instruction gets attached.

---

## 🗂️ Layer Summary

| Layer | Instruction | Type |
|-------|-------------|------|
| Layer 0 | `FROM ubuntu:24.04` | Intermediate |
| Layer 1 | `RUN apt update` | Intermediate |
| Layer 2 | `RUN apt install -y golang` | Intermediate |
| Layer 3 | `WORKDIR /app` | Intermediate |
| Layer 4 | `COPY ./server.go ./server.go` + `CMD [...]` | **Final** |

> 🔹 **Intermediate Layers** → Layer 0 to Layer 3
> 🔹 **Final Layer** → Layer 4 (this is the image that actually gets used)

---

## 🚀 Building the Final Image

```bash
docker build -t go_server:1.0.1 .
```

- This tags the **Layer 4 image** as `go_server:1.0.1`
- This is the actual image you build and run — everything before it was just intermediate steps toward this final result.

---

## 💡 Key Takeaway

Every `Dockerfile` instruction = **spin up temp container → apply change → commit → destroy temp container**, and the result of each commit becomes the base for the *next* instruction. This chain of tiny, cached, reusable layers is exactly what makes Docker builds fast and efficient (thanks to layer caching).

---

*Notes on how Docker builds images layer-by-layer under the hood.*
