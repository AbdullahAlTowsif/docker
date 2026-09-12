# 🐳 Docker Notes

> **IMAGE → CONTAINER**
> কারন image থেকে আমরা container run করি (We run containers *from* images)

---

## 📦 Basic Image & Container Commands

| # | Command | Description |
|---|---------|-------------|
| 1 | `docker images` | See all images |
| 2 | `docker ps` | See active/running containers |
| 3 | `docker ps -a` | See **all** containers, including stopped/hidden ones |
| 4 | `docker rmi image_id` | Remove an image |
| 4a | `docker rmi -f image_id` | Remove an image **forcefully** |
| 5 | `docker pull name:version` | Pull an image |

### 🔑 Understanding `-it`

| Flag | Meaning |
|------|---------|
| `-i` | Standard input (interactive) |
| `-t` | Pseudo TTY (terminal) |
| `-it` | Combined → **interactive mode** |

| # | Command | Description |
|---|---------|-------------|
| 6 | `docker run -it ubuntu:24.04 bash` | Run the image |
| 7 | `docker run --name my_ubuntu -it ubuntu:24.04 bash` | Run the image with a given container name |
| 8 | `docker exec -it my_ubuntu bash` | Enter a container via its name |
| 9 | `docker build .` | Build your own image |
| 10 | `docker build -t image_name .` | Build your own image with a given name |

---

## 🛠️ Towards the Dockerfile

Before writing a `Dockerfile`, here's the **manual step-by-step process** it replaces:

1. Pull the Ubuntu image
2. Run a container from the Ubuntu image
3. Go inside the container
4. Install Golang:
   ```bash
   apt update
   apt install -y golang
   ```
5. Create a directory `app`
6. Copy `server.go` from the host machine into the container at `/app/server.go`:
   ```bash
   docker cp server.go 4179ad0259b7:/app/server.go
   ```
   **Breaking it down:**
   - `cp` → copy
   - `server.go` → file to copy from the host machine
   - `4179ad0259b7:/app/server.go` → `container_id:path` (destination container & path)

7. Verify the copy was successful:
   ```bash
   cat server.go
   ```

8. Run the Go app inside the container, then test it:
   ```bash
   apt update
   apt install -y curl
   curl localhost:8080
   ```
   > ⚠️ **Note:** Before running the container, make sure the image runs and the server is actually listening — *then* execute the container.

9. Convert the running container into a new image:
   ```bash
   docker commit <container_id> go_server
   ```
   `docker commit <container_id> <image_name>` — this also creates an image.

   > 📝 **Note:** First run the `go_server` image and confirm the server is listening/running, then execute the container again to verify it responds correctly.

### 💡 Why a Dockerfile?

This manual process is **long and repetitive** — that's exactly why we use a **Dockerfile**: to automate all of the above into a single, repeatable build.

> **If the Dockerfile includes a `CMD` instruction:**
> ```bash
> docker run <image_name:version>
> ```

---

## ⚙️ Managing Containers

| # | Action | Command |
|---|--------|---------|
| 1 | Start a container | `docker start <container_id \| container_name>` |
| 2 | Restart a container | `docker restart <container_id \| container_name>` |
| 3 | Remove a container | `docker rm <container_id \| container_name>` |
| 4 | Stop a container | `docker stop <container_id \| container_name>` |

---

*Quick reference notes on Docker fundamentals — images, containers, and Dockerfile basics.*
