+++
date = "2019-10-12T23:45:00+02:00"
description = "Have you ever asked yourself what is the journey a packet follows in order to reach its destination?"
tags = ["networking"]
title = "The genius behind traceroute 📦"
+++
Have you ever asked yourself what is the journey a packet follows in order to reach its destination?

In this article, we’ll briefly cover how packets are transmitted between two clients (locally and remotely), and how the `traceroute` command allow us to trace a packet’s journey to its destination.

## Packet delivery 101

The way a packet reaches its destination varies **depending on the location** of the sender and receiver.

## Delivery of packets between a local network

![Photo by TechTerms](/uploads/lan.jpg "Photo by TechTerms")

In the case that both sender and receiver reside in the same **local network**, the sender has to find out the *Media Access Control* (MAC) address of the destination machine.

The MAC addresses are used to **uniquely** identify each node in a network. They’re commonly used in the lower layers of the *Ethernet* protocol, where all IP addresses are translated to MAC addresses.

In order for the sender to find out the **destination** machine’s MAC address, the *Address Resolution Protocol* (ARP) is used.

When the sender machine’s makes an ARP request, all nodes in the network will examine this request, but **only the machine which matches** the defined IP address in the ARP request will reply with its MAC address.

Once the sender receives the MAC address of the destination machine, it formats the package and sends it with the received MAC address.

## Delivery of packets between remote clients

![Photo by Lucidchart](/uploads/internetnetworkdiagram.png "Photo by Lucidchart")

Now that we know how packets are transmitted between peers of a local network, what happens when the clients are in **different networks**?

As in the previous case, the first requirement is to know the destination’s machine IP address.

Once we know the IP address of the destination machine, the sender checks if the machine associated to that IP address is within reach in its **local network**.

If it’s not, then the sender will forward that packet to its **network gateway** (e.g., a router).

When the packet reaches a router, the router checks its **forwarding tables** to see if it knows where to send the packet. If the remote destination is in the domain of the router’s destination tables, it’ll send the packet accordingly. In the other hand, if the remote address **is not listed** between the router’s forwarding tables, it’ll send the package to its defined gateway, repeating this process **until reaching** a router that has the remote destination’s IP address in its forwarding tables.

After various **network hops** between routers, the package will arrive to the remote destination’s router, which will then locally forward the packet to its final destination following the process we’ve covered earlier.

## Spying packets like 007

![You can call me traceroute](/uploads/james-bond-spectre.jpg "You can call me traceroute")

Great! We now know how packets are delivered, intra and inter networks. But, what if we want to know what is the **journey** a particular package had made in order to reach its final destination?

Thankfully, the `traceroute` command is at rescue. `traceroute` allows us to **trace** a route of all hopping suffered by a package in its way to the destination’s machine.

In order to accomplish this task, `traceroute` makes use of a security feature of the *Internet Protocol* (IP) which **limits the lifespan** (number of hops) a package can undercome.

The reason to limit the number of hops is to **prevent** a data packet to endlessly circulate in the network.

The easiest example to illustrate this issue is a network momentary loop, in which two or more routers start to indefinitely send **back and forth** between them the same package.

The solution to this problem is the *Time to live* (TTL) mechanism. Each packet has an initial TTL value that ranges between a maximum of 255 (the recommended initial value of a packet’s TTL is 64) and 0.

Each time a package hops from one router to another, the package’s TTL value is **reduced by one**.

If a packet’s TTL reaches zero before arriving to its destination, the last router to receive the package sends back an **error message to the original sender**, signaling that the package’s TTL has expired and **including** the IP address of the last package receiver.

So, in order to trace the journey of a package to its destination, `traceroute` sends a number of packages with an increasing TTL value starting from zero and incremented by one on each of the sent packages until reaching the final destination.

`traceroute` keeps a list of all routers that acknowledged back to the sender that the received package’s TTL had expired, and uses this list of error messages in order to **reconstruct the path** that the package has gone through.

Let’s put this into practise. To illustrate this, we’ll see the journey of two requests to two different clients.

Let’s try `tracert` with a request to `google.dk`.

To do this, type `traceroute google.dk` in your terminal. This command should produce an output similar to the one below. Take into account that the hops **will vary** depending on where you’re located!

    traceroute to google.dk (172.217.21.131), 64 hops max, 52 byte packets
     1  www.routerlogin.com (192.168.1.1)  0.636 ms  0.394 ms  0.319 ms
     2  91.101.56.1.generic-hostname.arrownet.dk (91.101.56.1)  5.537 ms  5.451 ms  5.267 ms
     3  85.24.4.1.generic-hostname.arrownet.dk (85.24.4.1)  6.186 ms  6.422 ms  6.121 ms
     4  62.61.140.107.generic-hostname.danskkabeltv.dk (62.61.140.107)  6.569 ms  6.780 ms  6.581 ms
     5  xe-1-0-3-0.alb2nqp8.dk.ip.tdc.net (195.215.109.5)  5.916 ms
        xe-1-0-1-0.alb2nqp8.dk.ip.tdc.net (80.196.13.205)  6.016 ms  5.978 ms
     6  ae0-0.stkm2nqp7.se.ip.tdc.net (83.88.2.128)  14.450 ms  14.481 ms  14.814 ms
     7  peer-as15169.stkm2nqp7.se.ip.tdc.net (128.76.59.41)  15.129 ms  15.210 ms  15.299 ms
     8  * * *
     9  209.85.242.10 (209.85.242.10)  17.325 ms
        arn11s02-in-f3.1e100.net (172.217.21.131)  15.000 ms
        209.85.242.10 (209.85.242.10)  17.291 ms

The asterisks displayed by `traceroute` correspond to packets **not acknowledged** within the expected timeout. In the example above, `arn11s02-in-f3.1e100.net` finally responded, which explains why the line 9 appears in the output.

In order to avoid this, you can **increase the default** timeout to a higher value, like 10 seconds, by using the `-w` option (e.g. `traceroute -w 10 google.dk`).

Now, try the same with another client using `traceroute [client]` and compare the outputs!

## Conclusion

In this article, you have learned **how packets are delivered** within local networks and between remote clients and how `traceroute` makes use of the **TTL mechanism** in order to track packages to its destination.

If you have any comments or doubts about this article, feel free to get in touch with me on [Twitter](https://www.twitter.com/ivanvmoreno) or at [ivan@ivan.build](mailto:ivan@ivan.build). Happy hacking!