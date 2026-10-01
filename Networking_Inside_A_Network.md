# Networking Inside A Network

This class explains **how computers communicate with each other inside the same network (LAN)**.  
It introduces **ARP (Address Resolution Protocol)** and shows the complete journey of a packet through Hubs and Switches.

---

## Scenario

- You (Computer A) and your friend (Computer D) are connected to the **same home router**.
- You created a simple HTTP server in Go that responds `Hello World` on `/hello` (running on port 3000).
- Your friend opens the browser and hits:  
  `http://192.168.1.5:3000/hello`
- We will see **exactly** how this request reaches your computer.

---

## 1. Packet Creation on the Source Computer (Friend’s Computer)

### Application Layer
- Browser creates an **HTTP GET** request for `/hello`.

### Transport Layer
- Source Port → Ephemeral port (e.g. `51000`)
- Destination Port → `3000`
- Data = HTTP request (becomes a TCP segment)

### Network Layer
- Source IP → Friend’s IP (`192.168.1.2`)
- Destination IP → Your IP (`192.168.1.5`)

### Data Link Layer – The Problem
- Source MAC → Friend’s own MAC (known)
- **Destination MAC → Unknown!**

The operating system only knows the Destination **IP**.  
It does **not** know the Destination **MAC** address.

---

## 2. ARP – Address Resolution Protocol

**ARP** is used to resolve (find) the MAC address of a given IP address.

### How ARP Works
1. The OS temporarily pauses the original TCP/HTTP request.
2. It creates a special **ARP Request** packet:
   - Source MAC = Own MAC
   - Destination MAC = `FF:FF:FF:FF:FF:FF` (Broadcast)
   - Type = ARP
   - Contains the Target IP (`192.168.1.5`)

3. This ARP Request is sent as a **broadcast**.

---

## 3. Journey of the ARP Request Through the Network

The network topology in the class contains:

- Hubs (L1 – blind flooding)
- Switches (L2 – intelligent, use CAM table)
- The internal Switch of the Home Router

### Behavior of Devices

| Device     | What it does with ARP Request                          |
|------------|--------------------------------------------------------|
| **Hub**    | Floods the frame to **all** other ports                |
| **Switch** | 1. Learns Source MAC → Port (writes in CAM table)<br>2. Sees Destination MAC = Broadcast → Floods to all other ports |
| **Computer** | Checks Destination IP. If not its own IP → **Rejects** |

Only the computer whose IP matches the Target IP in the ARP Request will accept it.

---

## 4. ARP Reply

When Computer D (your computer) receives the ARP Request:

1. It sees that the Target IP matches its own IP.
2. It creates an **ARP Reply**:
   - Source MAC = Its own MAC (D)
   - Destination MAC = Friend’s MAC (A)
   - Contains its own IP + MAC mapping

3. The ARP Reply travels back through the network.
4. Switches learn the MAC of Computer D along the way and update their **CAM tables**.
5. Friend’s computer receives the ARP Reply and stores the mapping in its **ARP Cache / ARP Table**:

```
IP Address          MAC Address
192.168.1.5    →    MAC of D
```

---

## 5. Sending the Real Data (After ARP)

Now that the Destination MAC is known:

1. The original HTTP request is resumed.
2. Data Link Layer is filled with:
   - Source MAC = Friend’s MAC
   - Destination MAC = Your MAC (D)
3. The frame is sent again.

### Journey of the Real Frame
- Hubs still flood.
- Switches now look up the Destination MAC in their **CAM table** and forward the frame **only** to the correct port (unicast).
- The frame reaches your computer efficiently.

Your computer:
1. Accepts the frame (Destination MAC matches).
2. Passes it up to Network Layer → Transport Layer → Application Layer.
3. The HTTP server on port 3000 responds with `Hello World`.
4. The response follows the reverse path back to your friend.

---

## 6. Same Network vs Different Network

Before putting the Destination MAC, the OS always checks:

```
Source IP  AND  Subnet Mask  →  Network Address A
Destination IP  AND  Subnet Mask  →  Network Address B
```

- If **Network Address A == Network Address B** → Same network  
  → Destination MAC = Real MAC of the target (resolved via ARP)

- If **different** → Outside network  
  → Destination MAC = MAC of the **Default Gateway** (Router)

---

## 7. Key Tables Involved

### On Computers
- **ARP Table / ARP Cache**  
  Maps IP → MAC

### On Switches
- **CAM Table** (also called MAC Address Table / Forwarding Database)  
  Maps MAC → Port

---

## 8. Important Takeaways

- Inside the same network, devices communicate using **MAC addresses**.
- IP is used to decide *who*, but MAC is used to actually deliver the frame.
- **ARP** is the protocol that maps IP → MAC.
- Hubs are dumb (always flood).
- Switches are smart (learn and unicast after learning).
- The real Router (L3) is **not involved** in pure internal LAN communication.
- Once ARP has resolved the MAC, it is cached so future packets do not need ARP again.

---

## What Comes Next

In the next classes we will see what happens when the Destination IP is **outside** the local network (how the packet reaches the Internet via the Router).

---

**End of Class Notes**

This document contains every major concept, flow, and explanation given in the video about networking **inside a single network**.
