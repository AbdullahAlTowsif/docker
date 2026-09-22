# TCP In Details

## Overview

This note dives deep into the **Transmission Control Protocol (TCP)** — the most important reliable transport-layer protocol used in modern networking (and essential for understanding Docker networking, port publishing, containers talking to each other, etc.).

TCP is a **connection-oriented**, **reliable**, **ordered**, and **error-checked** protocol that lives at the **Transport Layer (Layer 4)** of both the OSI and TCP/IP models.

---

## 1. Introduction to TCP Protocol

**TCP = Transmission Control Protocol**

- It is a set of **rules** (protocol) that the operating system implements.
- Application developers just say “send this data using TCP” — the OS handles the rest.
- Opposite of UDP (which is connectionless and unreliable).

**Key properties of TCP:**
- Connection-oriented
- Reliable delivery
- Ordered delivery
- Flow control
- Congestion control
- Error detection (checksum)

---

## 2. Sender ↔ Receiver Data Communication

Imagine two computers:

```
[Client / Sender]  ----------------  [Server / Receiver]
```

When an application (e.g. browser or backend) wants to send `"Hello World"`:

1. Application Layer creates the data
2. Transport Layer (TCP) takes the data and turns it into **segments**
3. Each segment gets Source Port + Destination Port
4. Network Layer adds Source IP + Destination IP
5. Data Link Layer adds Source MAC + Destination MAC
6. Physical Layer (NIC) sends the bits

On the receiving side the process is reversed (headers are stripped layer by layer).

> The application layer has **no idea** about ports, sequence numbers, or segments. It just says “send this”.

---

## 3. Transport Layer & Segmentation

At the Transport Layer:

- TCP breaks large data into smaller pieces called **segments**
- UDP creates **datagrams**

Each TCP segment contains:
- TCP Header
- Application data (payload)

---

## 4. Three-Way Handshake (Connection Establishment)

Before any data is sent, TCP performs a **3-way handshake**:

```
Client                          Server
  |                               |
  | -------- SYN ---------------->|     (1) Client: "I want to connect" (SYN flag)
  |                               |
  | <------ SYN + ACK ------------|     (2) Server: "OK, I agree" (SYN + ACK)
  |                               |
  | -------- ACK ---------------->|     (3) Client: "Confirmed" (ACK)
  |                               |
  | ======== CONNECTION ESTABLISHED ========
```

After this, both sides can send data.

---

## 5. TCP Header Structure

A typical TCP header is **20 bytes** (can be up to 60 bytes with options):

| Field                  | Size     | Description                              |
|------------------------|----------|------------------------------------------|
| Source Port            | 16 bits  | Port of the sender                       |
| Destination Port       | 16 bits  | Port of the receiver                     |
| Sequence Number        | 32 bits  | Position of the first byte in the stream |
| Acknowledgment Number  | 32 bits  | Next expected byte from the other side   |
| Data Offset            | 4 bits   | Header length                            |
| Reserved               | 3 bits   | Always 0                                 |
| Flags                  | 9 bits   | Control flags (SYN, ACK, FIN, etc.)      |
| Window Size            | 16 bits  | How much data the receiver can accept    |
| Checksum               | 16 bits  | Error detection                           |
| Urgent Pointer         | 16 bits  | Used with URG flag                       |
| Options (optional)     | variable | e.g. MSS, Window Scaling, Timestamps     |

---

## 6. Port Numbers & Ephemeral Ports

- **Well-known ports** (0–1023): HTTP (80), HTTPS (443), SSH (22), Telnet (23), SMTP (25), DNS (53) etc.
- **Registered ports** (1024–49151): MySql (3306), Microsoft SQL (1433), PostgreSql (5432), etc.
- **Ephemeral / Dynamic / Private ports** (49152–65535): Used by clients as source ports

When a client connects to a server:
- Server listens on a well-known port (e.g. 443)
- Client picks a random **ephemeral port** as its source port

This allows multiple connections from the same client to the same server.

---

## 7. Sequence Number & Acknowledgment Number

These two fields make TCP **reliable** and **ordered**.

- **Sequence Number**: Tracks every **byte** sent (not just packets)
- **Acknowledgment Number**: Tells the other side “I have received everything up to this byte — please send the next one”

Example:

```
Client sends 100 bytes starting at Seq = 1000
Server replies with ACK = 1100  (meaning “I got bytes 1000–1099”)
```

If a segment is lost, the receiver does **not** send a higher ACK → sender retransmits.

---

## 8. Important TCP Flags

| Flag | Meaning                          | Used in                  |
|------|----------------------------------|--------------------------|
| SYN  | Synchronize sequence numbers     | Connection start         |
| ACK  | Acknowledgment                   | Almost every segment     |
| FIN  | Finish (graceful close)          | Connection termination   |
| RST  | Reset (abort connection)         | Error situations         |
| PSH  | Push (deliver data immediately)  | Application data         |
| URG  | Urgent data                      | Rarely used today        |

---

## 9. Window Size & Flow Control

- **Window Size** tells the sender how many bytes the receiver is currently willing to accept.
- Prevents the sender from overwhelming the receiver (Flow Control).
- Related concept: **Congestion Control** (prevents overwhelming the network).

---

## 10. Checksum

- 16-bit field used for **error detection**.
- Calculated over the TCP header + data + a pseudo-header (containing IP addresses).
- If the checksum doesn’t match on the receiver side → segment is discarded.

---

## 11. Four-Way Termination (Connection Closing)

Graceful close uses **FIN** flags (usually 4 steps):

```
Client                          Server
  |                               |
  | -------- FIN ---------------->|     (1) Client: "I'm done sending"
  |                               |
  | <------ ACK ------------------|     (2) Server: "OK, got it"
  |                               |
  | <------ FIN ------------------|     (3) Server: "I'm also done"
  |                               |
  | -------- ACK ---------------->|     (4) Client: "OK, connection closed"
```

Sometimes it can be combined into fewer segments, but conceptually it is a 4-way process.

---

## Summary Diagram (Mental Model)

```
Application Data
       ↓
┌─────────────────────────────┐
│         TCP Segment         │
│  ┌───────────────────────┐  │
│  │ Source Port           │  │
│  │ Destination Port      │  │
│  │ Sequence Number       │  │
│  │ Acknowledgment Number │  │
│  │ Flags (SYN/ACK/FIN)   │  │
│  │ Window Size           │  │
│  │ Checksum              │  │
│  └───────────────────────┘  │
│         + Data              │
└─────────────────────────────┘
       ↓
     IP Packet → Frame → Wire
```

---

## Why This Matters for Docker

Understanding TCP deeply helps you understand:

- Why `-p 8080:80` works
- How containers communicate
- Port publishing / NAT
- Why you sometimes see `0.0.0.0:port->container:port/tcp`
- Connection timeouts, half-open connections, etc.

---

*Notes prepared based on the video content by Go With Habib.*
