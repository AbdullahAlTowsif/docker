# How the OS Chooses the Correct NIC – Clear Explanation

This document clears the common confusion about **who is sending the request** and **how the Operating System decides which network/NIC to use**.

---

## 1. The Confusing Part (What People Usually Misunderstand)

Many people see this URL:

```http
http://192.168.2.2:3000/hello
```

and think:

> “The computer with IP 192.168.2.2 is sending a request to me.”

**This is wrong.**

---

## 2. Correct Understanding

```http
http://192.168.2.2:3000/hello
```

means:

> **I** (my computer) am sending a request **to** the computer that has IP `192.168.2.2`.

### Simple Breakdown:

| Part              | Meaning                                      | Who |
|-------------------|----------------------------------------------|-----|
| `192.168.2.2`     | Destination IP                               | The **Server** |
| `3000`            | Destination Port                             | Port on the Server |
| `/hello`          | The path being requested                     | Resource on the Server |

- **Client** = My computer (the one making the request)
- **Server** = The computer at `192.168.2.2` (the one receiving the request)

---

## 3. Real Scenario from the Class

My computer has **three NICs** and three IP addresses:

| NIC Name   | My IP on that NIC | Connected Network   | Router |
|------------|-------------------|---------------------|--------|
| enp1s0     | 192.168.1.4       | 192.168.1.0/24      | r1     |
| **en0**    | **192.168.2.4**   | **192.168.2.0/24**  | **r2** |
| wlp2s2     | 10.10.1.4         | 10.10.1.0/24        | r3     |

I want to open this in the browser:

```http
http://192.168.2.2:3000/hello
```

This means I want to talk to a server that lives on the `192.168.2.0/24` network.

---

## 4. What Happens Step by Step

### Step 1: Application Layer
Browser creates a request:
```
GET /hello
```

### Step 2: Transport Layer
- Source Port → Random free port (example: 50154)
- Destination Port → 3000

### Step 3: Network Layer (The Decision Point)

Now the Operating System faces this question:

> “I have three IP addresses.  
> Which Source IP should I use?  
> Which NIC should I send this packet from?”

The OS looks at the **Routing Table** and does the following:

1. Takes the Destination IP → `192.168.2.2`
2. Performs AND operation with every NIC’s Subnet Mask
3. Finds that `192.168.2.2` belongs to the network `192.168.2.0/24`
4. Sees that this network is mapped to interface **en0**
5. Therefore:
   - Selected NIC = **en0**
   - Source IP = **192.168.2.4** (IP of en0)

### Step 4: Data Link Layer
- Source MAC = MAC address of en0
- Destination MAC = MAC address of 192.168.2.2 (found via ARP)

### Step 5: Physical Layer
The packet is converted to electrical/Wi-Fi signals and sent out through **en0**.

---

## 5. Final Packet (Simplified)

```
Application :  GET /hello
Transport   :  Source Port 50154  |  Destination Port 3000
Network     :  Source IP 192.168.2.4  |  Destination IP 192.168.2.2
Data Link   :  Source MAC (of en0)  |  Destination MAC (of 192.168.2.2)
```

---

## 6. Key Point to Remember Forever

| Question                                      | Answer |
|-----------------------------------------------|--------|
| Who is sending the request?                   | **My computer** |
| Who is receiving the request?                 | The computer at `192.168.2.2` |
| How does my computer know which NIC to use?   | By looking at the Routing Table + Longest Prefix Match |
| What becomes the Source IP?                   | The IP of the selected NIC |
| What becomes the Source MAC?                  | The MAC of the selected NIC |

---

## 7. One-Line Summary

> When I type `http://192.168.2.2:3000/hello`,  
> **I am the client**.  
> My Operating System decides which of my NICs is the correct path to reach that server,  
> and only then sends the request through that NIC.

---

**End of Clarification Notes**
