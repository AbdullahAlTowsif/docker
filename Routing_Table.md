# Routing Table

This class explains the **Routing Table** — the mechanism that allows a computer with multiple NICs to decide **which network interface** to use when sending a packet.

---

## 1. Why Do We Need a Routing Table?

In the previous classes we saw that a single computer can have **multiple NICs** and therefore multiple IP addresses, each belonging to a different network.

**Problem:**  
When the computer wants to send data, which Source IP and which NIC should it use?

The **Routing Table** solves this problem.

---

## 2. Scenario Setup

Imagine a computer connected to three different networks:

| NIC Name          | Connected To     | IP Address of Computer | Network Address     | Default Gateway   |
|-------------------|------------------|------------------------|---------------------|-------------------|
| **en0** (built-in) | Router 3        | `192.168.3.13`        | `192.168.3.0/24`   | `192.168.3.1`    |
| **en1** (PCI)      | Router 1        | `192.168.1.x`         | `192.168.1.0/24`   | `192.168.1.1`    |
| **en2** (Wi-Fi USB)| Router 2        | `192.168.2.x`         | `192.168.2.0/24`   | `192.168.2.1`    |

The computer now has **three IP addresses** and belongs to **three different networks**.

---

## 3. What is a Routing Table?

Every device that can make routing decisions (computers, routers, etc.) has a **Routing Table**.

### Important Columns in a Routing Table:

| Column              | Meaning |
|---------------------|--------|
| **Destination**     | Network address (or specific IP) that this route is for |
| **Gateway**         | Next hop (usually the router’s IP). Empty or `0.0.0.0` means directly connected |
| **Flags**           | Status of the route (U = Up, G = Gateway, etc.) |
| **Network Interface / Device** | Which NIC to use for this destination |
| **Metric / Expire** | Preference or lifetime of the route |

---

## 4. How Entries Are Added to the Routing Table

When a NIC gets an IP via **DHCP (DORA process)**, the DHCP Offer contains three important pieces of information:

1. Assigned IP address
2. Subnet Mask
3. Default Gateway

The Operating System then calculates the **Network Address**:

```
IP Address  AND  Subnet Mask  =  Network Address
```

Example:
```
192.168.3.13  AND  255.255.255.0  =  192.168.3.0
```

This network address is entered into the Routing Table mapped to that specific NIC.

### Example Routing Table (Simplified)

```
Destination          Gateway         Interface
------------------------------------------------
192.168.3.0/24       *               en0
192.168.1.0/24       *               en1
192.168.2.0/24       *               en2
0.0.0.0/0            192.168.3.1     en0          ← Default Route
```

- `*` or empty Gateway means the destination is on the **same network** (directly connected).
- The **Default Route** (`0.0.0.0/0` or written as `default`) is used when the destination does not match any specific network.

---

## 5. How the OS Chooses the Correct NIC (Step-by-Step)

### Case 1: Destination is on one of the local networks

Suppose the computer wants to send data to `192.168.3.10`.

1. Take the Destination IP: `192.168.3.10`
2. Perform **AND** operation with each NIC’s Subnet Mask to find the Network Address.
3. Look for a matching entry in the Routing Table.
4. Match found: `192.168.3.0/24` → Use interface **en0**
5. Source IP becomes the IP of en0 (`192.168.3.13`)
6. Destination MAC is resolved via ARP (same network communication)

### Case 2: Destination is outside all local networks

Suppose the computer wants to send data to `8.8.8.8` (Google DNS).

1. Destination IP: `8.8.8.8`
2. AND with all local Subnet Masks → No match with any local network.
3. Fall back to the **Default Route** (`0.0.0.0/0`)
4. Use interface **en0** and Gateway `192.168.3.1`
5. Source IP = IP of en0
6. Destination MAC = MAC address of the Default Gateway (resolved via ARP)

---

## 6. Full Packet Construction Flow (Using Routing Table)

1. **Application Layer** → Creates request (e.g. HTTP GET)
2. **Transport Layer** → Assigns Source Port (ephemeral) and Destination Port
3. **Network Layer**:
   - Looks up Routing Table using Destination IP
   - Selects Source IP and Outgoing Interface
4. **Data Link Layer**:
   - Source MAC = MAC of the selected NIC
   - Destination MAC = Resolved via ARP (either target host or Default Gateway)
5. **Physical Layer** → Converts to electrical / electromagnetic signal
6. OS sends the frame to the **selected NIC**

---

## 7. Commands to View the Routing Table

| Operating System | Command |
|------------------|--------|
| **Linux**        | `ip route` or `route -n` or `netstat -rn` |
| **macOS**        | `netstat -rn` or `route -n get default` |
| **Windows**      | `route print` |

---

## 8. Key Takeaways

- The Routing Table is the **decision-making system** of the Operating System for multi-NIC environments.
- Each connected network adds a route entry (Network Address → Interface).
- There is always a **Default Route** for destinations outside local networks.
- The OS uses the Destination IP + Subnet Mask to find the correct Network Address and then the correct Interface.
- Once the Interface is known, Source IP and Source MAC are automatically determined.
- Understanding the Routing Table is essential before studying how Docker chooses interfaces and for advanced networking topics.

---

## What Comes Next

- Loopback Interface (`lo` / `127.0.0.1`)
- How external routing works
- Docker Bridge Networking

---

**End of Class Notes**

This document contains a complete explanation of the Routing Table, how it is built, and how the Operating System uses it to choose the correct NIC when sending packets.
