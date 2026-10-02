# Visualize NICs In A Single Computer

This class is the practical visualization of the concepts introduced in the previous class (Multiple NICs).  
Here we actually **see** the network interfaces on a real computer and understand how the Operating System presents them.

---

## 1. Goal of This Class

In the previous class we learned theoretically that:
- A computer can have multiple NICs
- Each NIC can get its own IP address
- The computer can be connected to multiple networks at the same time

In this class we **visualize** these NICs so that the concept becomes concrete.

---

## 2. How to See Network Interfaces on a Computer

### On Linux (most common for Docker learning)

```bash
ip addr show
# or short form
ip a
```

or the older command:

```bash
ifconfig -a
```

### What you will typically see:

```
1: lo: <LOOPBACK,UP,LOWER_UP>
    inet 127.0.0.1/8

2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.1.10/24
    link/ether aa:bb:cc:dd:ee:ff

3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.2.15/24
    link/ether 11:22:33:44:55:66

4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 172.17.0.1/16
```

### Explanation of each interface:

| Interface   | Type                  | Meaning |
|-------------|-----------------------|--------|
| **lo**      | Loopback              | Special interface for the computer to talk to itself (`127.0.0.1`) |
| **eth0**    | Physical Ethernet     | Wired network card |
| **wlan0**   | Physical Wi-Fi        | Wireless network card |
| **docker0** | Virtual Bridge        | Created by Docker (we will study this later) |
| **veth***   | Virtual Ethernet      | Used by Docker containers |
| **br-***    | Bridge                | User-defined Docker networks |

---

## 3. Key Observations from Visualization

1. **Each interface has its own IP address**
   - eth0 → `192.168.1.10`
   - wlan0 → `192.168.2.15`
   - One computer = Multiple IPs

2. **Each interface has its own MAC address**
   - Physical NICs have hardware MAC addresses
   - Virtual interfaces also get MAC addresses

3. **Interfaces can be in different states**
   - `UP` → Active and working
   - `DOWN` → Disabled
   - `LOWER_UP` → Physical link is connected

4. **Docker creates its own virtual interfaces**
   - `docker0` is the default bridge
   - When you run containers, more virtual interfaces appear

---

## 4. Relationship with Previous Concepts

From previous classes we already know:

- Each NIC can independently run the **DORA** process (DHCP)
- Each NIC belongs to its own network
- The Operating System must later decide **which NIC** to use when sending a packet

This visualization confirms:
- Multiple NICs really exist
- They are visible to the Operating System
- The OS treats each of them as a separate network interface

---

## 5. Why This Visualization is Important

When we later study:
- Routing Table
- How OS chooses NIC
- Docker networking (bridge, host, macvlan, etc.)

…we will constantly refer to these interfaces (`eth0`, `wlan0`, `docker0`, `veth...`).

Without clearly seeing and understanding them, the next topics become confusing.

---

## 6. Summary

| Concept                        | What we learned |
|--------------------------------|-----------------|
| Multiple NICs                  | Real and visible on the computer |
| `ip addr` / `ifconfig`         | Commands to see all interfaces |
| Loopback (`lo`)                | Special interface for local communication |
| Physical vs Virtual interfaces | eth0/wlan0 are physical, docker0/veth are virtual |
| One computer = Multiple IPs    | Confirmed by looking at the interfaces |

---

## What Comes Next

**Class 049 – Routing Table**  
We will learn how the Operating System decides which interface (NIC) to use when sending a packet to a specific destination IP.

---

**End of Class Notes**

This document captures the visualization of Network Interfaces (NICs) inside a single computer as taught in the video.
