# First Computer & First Router - Part 1

## Introduction

From this class onward, we move into **real networking**.

The instructor tells a continuous story starting from the day you buy your first computer and your first router. This story will continue across multiple classes until you fully understand how a message reaches Facebook/WhatsApp/YouTube.

---

## Part 1: Buying Your First Computer

### Scenario
You buy your first desktop computer (PC) in your life and bring it home.

- It has a monitor (output device), keyboard (input device), and mouse (input device).
- At this moment, the computer has:
  - **No IP address**
  - **No MAC address**

### Why no IP or MAC?
- Older desktop computers often did **not** come with a built-in Network Interface Card (NIC).
- Without a NIC, the computer cannot participate in any network.

---

## Network Interface Card (NIC)

**NIC = Network Interface Card**

- It is a piece of **hardware**.
- Types of NIC:
  - Wired (Ethernet)
  - Wireless
  - USB NIC (external)
  - Internal (built into modern laptops and motherboards)

### What happens when you attach a NIC?

1. You install the NIC hardware into the computer.
2. The operating system needs a **driver** for the NIC (just like keyboard or mouse drivers).
   - Modern operating systems usually install the driver automatically.
3. Once the NIC is recognized:
   - The computer gets a **MAC address** (because the MAC address is burned into the NIC hardware).
   - The operating system does not like having no IP address, so it assigns a temporary IP using **APIPA**.

---

## APIPA – Automatic Private IP Addressing

**APIPA** = Automatic Private IP Addressing

- When a computer has a NIC but cannot get an IP from a DHCP server, the OS automatically assigns itself a private IP from this range:

```
169.254.0.0  →  169.254.255.255
```

- This is a **temporary / link-local** IP.
- It only works for communication on the local link (same physical network). It is not useful for real internet communication.

---

## IP Address vs MAC Address

| Aspect              | IP Address                          | MAC Address                          |
|---------------------|-------------------------------------|--------------------------------------|
| Nature              | **Logical** address                 | **Physical** address                 |
| Can it change?      | Yes (can change anytime)            | No (fixed in the hardware)           |
| Where does it come from? | Assigned by OS / DHCP / Admin   | Burned into the NIC by manufacturer  |
| Size                | 32 bits (IPv4)                      | 48 bits (6 bytes)                    |
| Purpose             | Identify a device on a network (logical) | Identify a specific network interface (physical) |
| Analogy             | House address (can change if you move) | Permanent physical location of the building |

- **MAC Address** example format: `12:13:14:15:16:17` (six groups of 8 bits each, values 0–255).
- When the NIC is attached, that MAC address becomes the computer’s MAC address.

After attaching the NIC, the computer now has:
- One **IP address** (temporary via APIPA)
- One **MAC address** (from the NIC)

---

## Part 2: Buying Your First Router

After some time, you buy a cheap home router (e.g., 2000–3000 Taka) and bring it home.

### Important: No Internet yet
You only plugged the router into power. You have **not** connected it to any ISP (Internet Service Provider) yet.

### Router Interfaces

A router has **two main faces / interfaces**:

1. **LAN Interface** (Local Area Network side)
2. **WAN Interface** (Wide Area Network / Internet side)

**Interface** means the part that is visible/accessible from the outside (like the eyes, nose, clothes of a human — the external appearance). What is inside (heart, brain, etc.) is different.

- **LAN Interface**: Connected to your home devices (computers, phones, etc.)
- **WAN Interface**: Connected to the internet (ISP)

When you power on a brand-new router (with no internet connection):

- The router automatically configures a **pre-set IP address** on its **LAN interface**.
- Common default LAN IP: `192.168.0.1` or `192.168.1.1`
- The **WAN interface** has **no IP** yet (because it is not connected to the internet).

---

## Connecting Computer to Router

You connect the computer’s NIC to the router’s LAN port using an **Ethernet cable**.

Now both devices have IPs:
- Computer → Temporary APIPA IP (e.g., 169.254.x.x)
- Router LAN interface → Pre-configured IP (e.g., 192.168.1.1)

### What happens next? → DHCP

Inside the router, there is a program called **DHCP**.

**DHCP** = **Dynamic Host Configuration Protocol**

When the router is powered on, this program starts running.  
A running DHCP program is called a **DHCP Server**.

#### The Four Steps of DHCP (DORA)

When the computer is connected to the router, the following automatic conversation happens:

| Step | Name            | Who does it?     | Meaning |
|------|-----------------|------------------|---------|
| 1    | **Discover**    | Computer → Router | “I need an IP address. Is there any DHCP server here?” |
| 2    | **Offer**       | Router → Computer | “Here, I can give you this IP address (e.g., 192.168.1.10) for 24 hours.” |
| 3    | **Request**     | Computer → Router | “Please assign me the IP address you offered.” |
| 4    | **Acknowledgement (ACK)** | Router → Computer | “Okay, that IP is now yours.” |

After the ACK:
- The computer **discards** the temporary APIPA IP.
- The computer now uses the new IP given by the router as its main IP.
- The router stores a mapping of:
  - Computer’s **MAC address** ↔ Assigned **IP address**

This mapping is kept somewhere inside the router (details in future classes).

---

## Summary of the Story So Far

1. You buy a computer → No IP, No MAC.
2. You install a NIC → Computer gets MAC address + temporary APIPA IP.
3. You buy a router and power it on → Router gets a pre-configured IP on its LAN interface.
4. You connect computer ↔ router with Ethernet cable.
5. DHCP (DORA process) runs → Computer gets a proper private IP from the router.
6. Router remembers the MAC ↔ IP mapping.

---

## What Comes Next

In the next class, the story continues:
- What happens when you connect the **router’s WAN interface** to the real internet (ISP).
- How the router gets a public IP.
- How devices inside the home can access the internet.

This is only **Part 1** of a long story that will eventually explain:
- How a WhatsApp / Facebook message reaches your friend
- How a YouTube video reaches your screen

---

## Key Terms Introduced

- **NIC** – Network Interface Card
- **APIPA** – Automatic Private IP Addressing (`169.254.0.0/16`)
- **MAC Address** – Physical address (48 bits)
- **IP Address** – Logical address
- **LAN Interface** – Local side of the router
- **WAN Interface** – Internet side of the router
- **DHCP** – Dynamic Host Configuration Protocol
- **DORA** – Discover → Offer → Request → Acknowledgement
- **DHCP Server** – The running DHCP program inside the router

---

**Note:** This document captures the complete story, all technical explanations, analogies, and important concepts presented in the video without omitting any necessary information.
