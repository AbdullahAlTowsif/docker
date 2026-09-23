# First Computer & First Router - Part 2

## Recap of Part 1

From the previous class:

1. You attached a **NIC** to your first computer.
2. The OS assigned a temporary IP via **APIPA** (`169.254.x.x`).
3. You bought a router. The router has two interfaces:
   - **LAN Interface**
   - **WAN Interface**
4. The router has a pre-configured IP on its LAN interface (e.g., `192.168.1.1`).
5. You connected the computer to the router with an Ethernet cable.
6. The **DHCP server** inside the router ran the **DORA** process:
   - **D**iscover
   - **O**ffer
   - **R**equest
   - **A**cknowledgement
7. The computer received a proper private IP from the router, and the router stored the MAC ↔ IP mapping.

**Big unanswered question from Part 1:**  
How does the computer know the router’s IP (or MAC) to send the first DHCP Discover request? It doesn’t know either of them yet.

The answer lies in **Subnet**, **Subnet Mask**, **Network Address**, **Broadcast Address**, and **Broadcasting**.

---

## What is a Network?

A **network** is a group of devices connected together (e.g., your computer, mobile, printer, and brother’s computer all connected to the same router).

- Many networks connected to each other form an **Internetwork**.
- The word **Internet** comes from **Internetwork**.

---

## What is a Subnet?

**Subnet** = **Sub** + **Network** = a smaller network created by dividing a large network.

Analogy (Bangladesh administrative divisions):
- Country → Divisions → Districts → Upazilas (sub-districts)
- A large network is divided into smaller sub-networks (subnets).

Subnetting allows network engineers to control how many devices can join a particular network and provides better organization and security.

---

## IP Address Structure (Reminder)

An IPv4 address is **32 bits** long, written as four **octets** (each 8 bits):

```
192.168.1.10
```

Each octet can hold a value from **0 to 255**.

---

## Subnet Mask

The **Subnet Mask** tells us which part of the IP address is the **Network** portion and which part is the **Host** portion.

### Example 1: Common Home Network

| Item              | Value                  |
|-------------------|------------------------|
| Device IP         | `192.168.1.10`         |
| Subnet Mask       | `255.255.255.0`        |

- `255` means all 8 bits are **1** (fixed / network part).
- `0` means all 8 bits are **0** (can change / host part).

**Interpretation:**
- First three octets (`192.168.1`) are **fixed** (Network portion).
- Last octet can be any value from **0 to 255** (Host portion).

**Total IPs available:** 256 (0–255)  
**Reserved:**
- First IP (`192.168.1.0`) → **Network Address**
- Last IP (`192.168.1.255`) → **Broadcast Address**

**Usable IPs:** 254 (can be assigned to devices)

---

### Example 2: Smaller Subnet

| Item              | Value                  |
|-------------------|------------------------|
| Subnet Mask       | `255.255.255.240`      |

- Binary of 240 = `11110000` (first 4 bits fixed, last 4 bits free)
- Only 16 total IPs (0–15 in the last part)
- 2 reserved → **14 usable** IPs

---

### Example 3: Very Small Subnet (Only 2 Devices)

| Item              | Value                  |
|-------------------|------------------------|
| Subnet Mask       | `255.255.255.252`      |

- Only 4 total IPs
- 2 reserved → **2 usable** IPs (perfect for computer + mobile only)

This is how you can restrict a router so that only a specific number of devices can get an IP.

---

## CIDR Notation (Classless Inter-Domain Routing)

Instead of writing the full subnet mask, we use a shorter form called **CIDR Notation**:

```
192.168.1.10/24
```

- `/24` means the **first 24 bits** are fixed (network portion).
- Remaining 8 bits are for hosts.
- Equivalent to subnet mask `255.255.255.0`.

### More Examples

| CIDR          | Equivalent Subnet Mask   | Usable Hosts (approx) |
|---------------|--------------------------|-----------------------|
| `/24`         | `255.255.255.0`          | 254                   |
| `/28`         | `255.255.255.240`        | 14                    |
| `/26`         | `255.255.255.192`        | 62                    |
| `/16`         | `255.255.0.0`            | 65,534                |
| `/30`         | `255.255.255.252`        | 2                     |

---

## Network Address & Broadcast Address

Given an IP + Subnet Mask (or CIDR):

1. **Network Address**  
   - The very first address of the subnet.  
   - All host bits are set to **0**.  
   - Cannot be assigned to any device.

2. **Broadcast Address**  
   - The very last address of the subnet.  
   - All host bits are set to **1**.  
   - Used to send a message to **every device** on that subnet.  
   - Cannot be assigned to any device.

**Example:**
```
IP:          192.168.1.10
Subnet Mask: 255.255.255.0   (or /24)

Network Address:    192.168.1.0
Broadcast Address:  192.168.1.255
Usable IPs:         192.168.1.1 – 192.168.1.254
```

---

## How the Computer Discovers the Router (The Missing Piece)

When the computer is first connected to the router:

- It does **not** know the router’s IP.
- It does **not** know the router’s MAC address.

**Solution → Broadcasting**

1. The computer sends a **DHCP Discover** packet.
2. Destination IP = `255.255.255.255` (limited broadcast address)
3. Destination MAC = `FF:FF:FF:FF:FF:FF` (broadcast MAC)

This packet reaches **every device** on the local network (including the router).

- The router sees the Discover packet and replies with an **Offer**.
- From the Offer, the computer learns:
  - The router’s IP address
  - The router’s MAC address
- Now the computer can talk directly to the router for the remaining DORA steps (Request & Acknowledgement).

This is why understanding **Broadcast Address** is critical.

---

## Practical Benefits of Subnetting

1. **Control the number of devices** that can join a network.
2. **Security** – Limit access (e.g., only 2 devices allowed).
3. **Network Design** – Large organizations divide networks by floors, departments, etc.
4. Efficient use of IP addresses.

Network engineers use subnetting extensively when designing university campuses, offices, data centers, etc.

---

## Summary of Concepts Learned in This Class

| Concept              | Meaning |
|----------------------|---------|
| **Network**          | Group of connected devices |
| **Subnet**           | Smaller network created by dividing a large network |
| **Subnet Mask**      | Defines which bits are network vs host |
| **CIDR Notation**    | Short way to write subnet mask (e.g., `/24`) |
| **Network Address**  | First IP of the subnet (reserved) |
| **Broadcast Address**| Last IP of the subnet (reserved, used for broadcasting) |
| **Broadcasting**     | Sending a packet to every device on the local network (`255.255.255.255` + `FF:FF:FF:FF:FF:FF`) |

---

## What Comes Next

In the next class, the story continues:
- Connecting the router’s **WAN interface** to the real Internet (ISP).
- How the router gets a public IP.
- How devices inside the home can access the internet.

---

**Note:** This document contains every important technical explanation, example, analogy, and concept presented in the video without omitting necessary information.
