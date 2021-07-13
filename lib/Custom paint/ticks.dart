import 'package:flutter/material.dart';
/*
{
  "id": "179b1a0c33d71d2f",
  "threadId": "179b1a0c33d71d2f",
  "labelIds": [
    "IMPORTANT",
    "CATEGORY_UPDATES",
    "INBOX"
  ],
  "snippet": "Google APIs Explorer was granted access to your Google Account testingacc.g00gle@gmail.com If you did not grant access, you should check this activity and secure your account. Check activity You can",
  "payload": {
    "partId": "",
    "mimeType": "multipart/alternative",
    "filename": "",
    "headers": [
      {
        "name": "Delivered-To",
        "value": "testingacc.g00gle@gmail.com"
      },
      {
        "name": "Received",
        "value": "by 2002:ab0:6897:0:0:0:0:0 with SMTP id t23csp338815uar;        Thu, 27 May 2021 23:19:33 -0700 (PDT)"
      },
      {
        "name": "X-Received",
        "value": "by 2002:a5d:87c4:: with SMTP id q4mr5616561ios.141.1622182773323;        Thu, 27 May 2021 23:19:33 -0700 (PDT)"
      },
      {
        "name": "ARC-Seal",
        "value": "i=1; a=rsa-sha256; t=1622182773; cv=none;        d=google.com; s=arc-20160816;        b=U4J1nlVXhOeeHw5HdY2ZGWJPbF1J6ZqTfYt9vDH0QDYgmiOEom6nN/5jXqUTJGrfRU         Bj9ZIaHFyvcMvyMiYBxP+J5QrBS5zo/o/XyS0kizqihq2G7gKofUOZtHcM9vqj2/P2cf         nJStBxjxfUyDLX/aQuEnI+GgS+eU7ScWiWg0S1vKKGYchuKar7Ol244DSv48mAoQVGz0         Mux4Svp3QGO+Kz9t0BeJVN+GNDg6qmqTwyqaTeyGcI6hs1DPyKz2VYtHcyf5pOfXtP2f         t36pAi/Wv4Ze7GJ1dPfdCyztKXw2L9AXWOSNvdMosmQifxfEo5LgWJgYsrMSjMUXYDwi         qOqA=="
      },
      {
        "name": "ARC-Message-Signature",
        "value": "i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;        h=to:from:subject:message-id:feedback-id:date:mime-version         :dkim-signature;        bh=zl6H8JPU9ZePfh0OyFOxXhF7i41ptN2/TMt4XDDfKJg=;        b=GUUu26oPNI7IhZz5UiR/UE4uV8X/Lit4S9ymuUsQhJnQOlxlb1CjgEcVd6oYjUx0nX         95KwAFo/IJ1twh+9T/lNkbNWQaw5nzYSN7359USFx1X4khKRS2En7GTODGhFNhHuKUEN         rI3DuaC9OO6rjqbJ4SkgPIXEBSgkJsqd0i9qhttP6buPtxVUgbLKkKLmjZbQ4O7odXZa         4uqdftPPPQLCinKkKhDDodvSs+GES6IzWcHnZZMhIcpuThtRUrWBr+k9/Rf2ivX2pKE7         ld7BYgA7kj0xO2f4du2PUJj3diU2cqttEXioG+NXsdtmmLxVk2qLhoihuFu2RudeA0jr         Cd8w=="
      },
      {
        "name": "ARC-Authentication-Results",
        "value": "i=1; mx.google.com;       dkim=pass header.i=@accounts.google.com header.s=20161025 header.b=KUGYza9R;       spf=pass (google.com: domain of 3dyuwyagtafofg-j6hdq244gmflk.8gg8d6.4ge@gaia.bounces.google.com designates 209.85.220.73 as permitted sender) smtp.mailfrom=3dYuwYAgTAFoFG-J6HDQ244GMFLK.8GG8D6.4GE@gaia.bounces.google.com;       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=accounts.google.com"
      },
      {
        "name": "Return-Path",
        "value": "\u003c3dYuwYAgTAFoFG-J6HDQ244GMFLK.8GG8D6.4GE@gaia.bounces.google.com\u003e"
      },
      {
        "name": "Received",
        "value": "from mail-sor-f73.google.com (mail-sor-f73.google.com. [209.85.220.73])        by mx.google.com with SMTPS id k11sor6891092jad.2.2021.05.27.23.19.33        for \u003ctestingacc.g00gle@gmail.com\u003e        (Google Transport Security);        Thu, 27 May 2021 23:19:33 -0700 (PDT)"
      },
      {
        "name": "Received-SPF",
        "value": "pass (google.com: domain of 3dyuwyagtafofg-j6hdq244gmflk.8gg8d6.4ge@gaia.bounces.google.com designates 209.85.220.73 as permitted sender) client-ip=209.85.220.73;"
      },
      {
        "name": "Authentication-Results",
        "value": "mx.google.com;       dkim=pass header.i=@accounts.google.com header.s=20161025 header.b=KUGYza9R;       spf=pass (google.com: domain of 3dyuwyagtafofg-j6hdq244gmflk.8gg8d6.4ge@gaia.bounces.google.com designates 209.85.220.73 as permitted sender) smtp.mailfrom=3dYuwYAgTAFoFG-J6HDQ244GMFLK.8GG8D6.4GE@gaia.bounces.google.com;       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=accounts.google.com"
      },
      {
        "name": "DKIM-Signature",
        "value": "v=1; a=rsa-sha256; c=relaxed/relaxed;        d=accounts.google.com; s=20161025;        h=mime-version:date:feedback-id:message-id:subject:from:to;        bh=zl6H8JPU9ZePfh0OyFOxXhF7i41ptN2/TMt4XDDfKJg=;        b=KUGYza9Rzu645Xro8k0/2JPFfhEOuI1lJk709cUJjXLi0ICb5/mE43zJRRDDNa6Qy7         suvaJsbdhXCdO5Yl3gBCBpBv7JwS+/04ZV/Ai6K/QulmaZfzVN86KC7c/P1dLzEDDYAK         X8PDquz7/bsoYofnBpBsdw/lAWkUmMl+35quuJAHdhmDe0ABg320Cuo6jxq0wdwEbr3a         zzpL4u/D3sBnoSNdKvXiZ4KBn9ElR21xxJ8MXfT0pfP5G+r6/Sj3dxgFYeSYbkfBZ1WC         MDrCcE+QGYAAuRTxXQ0HQkKB5JrfAVdZjPHq60I3tplKBtflmSJdgUEBeZU/HciSfAM9         Az5g=="
      },
      {
        "name": "X-Google-DKIM-Signature",
        "value": "v=1; a=rsa-sha256; c=relaxed/relaxed;        d=1e100.net; s=20161025;        h=x-gm-message-state:mime-version:date:feedback-id:message-id:subject         :from:to;        bh=zl6H8JPU9ZePfh0OyFOxXhF7i41ptN2/TMt4XDDfKJg=;        b=EcDH8j1bBuR9xHJOycaQu8gQa94dlJ31mxqfv92ZiGTZ0yzp1k7CPGpbavOxSRPcrT         nADpXnP2Qei2g8KaX+ZkhZsU5GWfKv5dQUqDCkyzG3njuR6JYIlrysdVRT/64lTYrCJZ         miJqP1uib+aDU8Qi9ptGE/alAKtFuQVoi8l4dRWA/czBZBzymw0DYx69x9N0QNmJ5yWC         WqHsKDboO7SPiONLa3qyXc8PsSNEcnEKlEO7JMNiV1CpgPpwvU02HmiLv+NQThy1fW34         n3PUcT5+HsGPCnG3dtwCeK8EdXnsc9kSfT/mN5sEcMzC6DH8tXnW+wOCo+Q9WINScbUc         NVIA=="
      },
      {
        "name": "X-Gm-Message-State",
        "value": "AOAM531Ond0EIcODZuFfqEldztj7fPqeX5S0RaVsUr/m3ydKXGILmx3/ 10sEGIj8HfDgTTQDTHCqG9WduWlQL5objKAPEMOvVw=="
      },
      {
        "name": "X-Google-Smtp-Source",
        "value": "ABdhPJw5vIxqzUBhzxdAHNiwvnt6JkmEJ/x1yk2b/BiyXWXiCBtgeSfBSlKIHeMBTDk62RpKWSmhG2BboEkB1y1SN4+MUw=="
      },
      {
        "name": "MIME-Version",
        "value": "1.0"
      },
      {
        "name": "X-Received",
        "value": "by 2002:a05:6638:2181:: with SMTP id s1mr7068047jaj.66.1622182773127; Thu, 27 May 2021 23:19:33 -0700 (PDT)"
      },
      {
        "name": "Date",
        "value": "Fri, 28 May 2021 06:19:32 GMT"
      },
      {
        "name": "X-Account-Notification-Type",
        "value": "127-anexp#nret-fa"
      },
      {
        "name": "Feedback-ID",
        "value": "127-anexp#nret-fa:account-notifier"
      },
      {
        "name": "X-Notifications",
        "value": "7fa5632deea00000"
      },
      {
        "name": "Message-ID",
        "value": "\u003cL4Mwp_W2LCLEL0V-GErhEQ@notifications.google.com\u003e"
      },
      {
        "name": "Subject",
        "value": "Security alert"
      },
      {
        "name": "From",
        "value": "Google \u003cno-reply@accounts.google.com\u003e"
      },
      {
        "name": "To",
        "value": "testingacc.g00gle@gmail.com"
      },
      {
        "name": "Content-Type",
        "value": "multipart/alternative; boundary=\"000000000000f3f8b205c35ddb90\""
      }
    ],
    "body": {
      "size": 0
    },
    "parts": [
      {
        "partId": "0",
        "mimeType": "text/plain",
        "filename": "",
        "headers": [
          {
            "name": "Content-Type",
            "value": "text/plain; charset=\"UTF-8\"; format=flowed; delsp=yes"
          },
          {
            "name": "Content-Transfer-Encoding",
            "value": "base64"
          }
        ],
        "body": {
          "size": 699,
          "data": "W2ltYWdlOiBHb29nbGVdDQpHb29nbGUgQVBJcyBFeHBsb3JlciB3YXMgZ3JhbnRlZCBhY2Nlc3MgdG8geW91ciBHb29nbGUgQWNjb3VudA0KDQoNCnRlc3RpbmdhY2MuZzAwZ2xlQGdtYWlsLmNvbQ0KDQpJZiB5b3UgZGlkIG5vdCBncmFudCBhY2Nlc3MsIHlvdSBzaG91bGQgY2hlY2sgdGhpcyBhY3Rpdml0eSBhbmQgc2VjdXJlIHlvdXINCmFjY291bnQuDQpDaGVjayBhY3Rpdml0eQ0KPGh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbS9BY2NvdW50Q2hvb3Nlcj9FbWFpbD10ZXN0aW5nYWNjLmcwMGdsZUBnbWFpbC5jb20mY29udGludWU9aHR0cHM6Ly9teWFjY291bnQuZ29vZ2xlLmNvbS9hbGVydC9udC8xNjIyMTgyNzcyMDAwP3JmbiUzRDEyNyUyNnJmbmMlM0QxJTI2ZWlkJTNENTExMjY0MjQxNjEyMzM2NzM0MiUyNmV0JTNEMCUyNmFuZXhwJTNEbnJldC1mYT4NCllvdSBjYW4gYWxzbyBzZWUgc2VjdXJpdHkgYWN0aXZpdHkgYXQNCmh0dHBzOi8vbXlhY2NvdW50Lmdvb2dsZS5jb20vbm90aWZpY2F0aW9ucw0KWW91IHJlY2VpdmVkIHRoaXMgZW1haWwgdG8gbGV0IHlvdSBrbm93IGFib3V0IGltcG9ydGFudCBjaGFuZ2VzIHRvIHlvdXINCkdvb2dsZSBBY2NvdW50IGFuZCBzZXJ2aWNlcy4NCsKpIDIwMjEgR29vZ2xlIExMQywgMTYwMCBBbXBoaXRoZWF0cmUgUGFya3dheSwgTW91bnRhaW4gVmlldywgQ0EgOTQwNDMsIFVTQQ0K"
        }
      },
      {
        "partId": "1",
        "mimeType": "text/html",
        "filename": "",
        "headers": [
          {
            "name": "Content-Type",
            "value": "text/html; charset=\"UTF-8\""
          },
          {
            "name": "Content-Transfer-Encoding",
            "value": "quoted-printable"
          }
        ],
        "body": {
          "size": 4754,
          "data": "PCFET0NUWVBFIGh0bWw-PGh0bWwgbGFuZz0iZW4iPjxoZWFkPjxtZXRhIG5hbWU9ImZvcm1hdC1kZXRlY3Rpb24iIGNvbnRlbnQ9ImVtYWlsPW5vIi8-PG1ldGEgbmFtZT0iZm9ybWF0LWRldGVjdGlvbiIgY29udGVudD0iZGF0ZT1ubyIvPjxzdHlsZSBub25jZT0iYzlzaFR0dTN1TE80c080anFCeWNKQSI-LmF3bCBhIHtjb2xvcjogI0ZGRkZGRjsgdGV4dC1kZWNvcmF0aW9uOiBub25lO30gLmFibWwgYSB7Y29sb3I6ICMwMDAwMDA7IGZvbnQtZmFtaWx5OiBSb2JvdG8tTWVkaXVtLEhlbHZldGljYSxBcmlhbCxzYW5zLXNlcmlmOyBmb250LXdlaWdodDogYm9sZDsgdGV4dC1kZWNvcmF0aW9uOiBub25lO30gLmFkZ2wgYSB7Y29sb3I6IHJnYmEoMCwgMCwgMCwgMC44Nyk7IHRleHQtZGVjb3JhdGlvbjogbm9uZTt9IC5hZmFsIGEge2NvbG9yOiAjYjBiMGIwOyB0ZXh0LWRlY29yYXRpb246IG5vbmU7fSBAbWVkaWEgc2NyZWVuIGFuZCAobWluLXdpZHRoOiA2MDBweCkgey52MnNwIHtwYWRkaW5nOiA2cHggMzBweCAwcHg7fSAudjJyc3Age3BhZGRpbmc6IDBweCAxMHB4O319IEBtZWRpYSBzY3JlZW4gYW5kIChtaW4td2lkdGg6IDYwMHB4KSB7Lm1kdjJydyB7cGFkZGluZzogNDBweCA0MHB4O319IDwvc3R5bGU-PGxpbmsgaHJlZj0iLy9mb250cy5nb29nbGVhcGlzLmNvbS9jc3M_ZmFtaWx5PUdvb2dsZStTYW5zIiByZWw9InN0eWxlc2hlZXQiIHR5cGU9InRleHQvY3NzIiBub25jZT0iYzlzaFR0dTN1TE80c080anFCeWNKQSIvPjwvaGVhZD48Ym9keSBzdHlsZT0ibWFyZ2luOiAwOyBwYWRkaW5nOiAwOyIgYmdjb2xvcj0iI0ZGRkZGRiI-PHRhYmxlIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIHN0eWxlPSJtaW4td2lkdGg6IDM0OHB4OyIgYm9yZGVyPSIwIiBjZWxsc3BhY2luZz0iMCIgY2VsbHBhZGRpbmc9IjAiIGxhbmc9ImVuIj48dHIgaGVpZ2h0PSIzMiIgc3R5bGU9ImhlaWdodDogMzJweDsiPjx0ZD48L3RkPjwvdHI-PHRyIGFsaWduPSJjZW50ZXIiPjx0ZD48ZGl2IGl0ZW1zY29wZSBpdGVtdHlwZT0iLy9zY2hlbWEub3JnL0VtYWlsTWVzc2FnZSI-PGRpdiBpdGVtcHJvcD0iYWN0aW9uIiBpdGVtc2NvcGUgaXRlbXR5cGU9Ii8vc2NoZW1hLm9yZy9WaWV3QWN0aW9uIj48bGluayBpdGVtcHJvcD0idXJsIiBocmVmPSJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vQWNjb3VudENob29zZXI_RW1haWw9dGVzdGluZ2FjYy5nMDBnbGVAZ21haWwuY29tJmFtcDtjb250aW51ZT1odHRwczovL215YWNjb3VudC5nb29nbGUuY29tL2FsZXJ0L250LzE2MjIxODI3NzIwMDA_cmZuJTNEMTI3JTI2cmZuYyUzRDElMjZlaWQlM0Q1MTEyNjQyNDE2MTIzMzY3MzQyJTI2ZXQlM0QwJTI2YW5leHAlM0RucmV0LWZhIi8-PG1ldGEgaXRlbXByb3A9Im5hbWUiIGNvbnRlbnQ9IlJldmlldyBBY3Rpdml0eSIvPjwvZGl2PjwvZGl2Pjx0YWJsZSBib3JkZXI9IjAiIGNlbGxzcGFjaW5nPSIwIiBjZWxscGFkZGluZz0iMCIgc3R5bGU9InBhZGRpbmctYm90dG9tOiAyMHB4OyBtYXgtd2lkdGg6IDUxNnB4OyBtaW4td2lkdGg6IDIyMHB4OyI-PHRyPjx0ZCB3aWR0aD0iOCIgc3R5bGU9IndpZHRoOiA4cHg7Ij48L3RkPjx0ZD48ZGl2IHN0eWxlPSJib3JkZXItc3R5bGU6IHNvbGlkOyBib3JkZXItd2lkdGg6IHRoaW47IGJvcmRlci1jb2xvcjojZGFkY2UwOyBib3JkZXItcmFkaXVzOiA4cHg7IHBhZGRpbmc6IDQwcHggMjBweDsiIGFsaWduPSJjZW50ZXIiIGNsYXNzPSJtZHYycnciPjxpbWcgc3JjPSJodHRwczovL3d3dy5nc3RhdGljLmNvbS9pbWFnZXMvYnJhbmRpbmcvZ29vZ2xlbG9nby8yeC9nb29nbGVsb2dvX2NvbG9yXzc0eDI0ZHAucG5nIiB3aWR0aD0iNzQiIGhlaWdodD0iMjQiIGFyaWEtaGlkZGVuPSJ0cnVlIiBzdHlsZT0ibWFyZ2luLWJvdHRvbTogMTZweDsiIGFsdD0iR29vZ2xlIj48ZGl2IHN0eWxlPSJmb250LWZhbWlseTogJiMzOTtHb29nbGUgU2FucyYjMzk7LFJvYm90byxSb2JvdG9EcmFmdCxIZWx2ZXRpY2EsQXJpYWwsc2Fucy1zZXJpZjtib3JkZXItYm90dG9tOiB0aGluIHNvbGlkICNkYWRjZTA7IGNvbG9yOiByZ2JhKDAsMCwwLDAuODcpOyBsaW5lLWhlaWdodDogMzJweDsgcGFkZGluZy1ib3R0b206IDI0cHg7dGV4dC1hbGlnbjogY2VudGVyOyB3b3JkLWJyZWFrOiBicmVhay13b3JkOyI-PGRpdiBzdHlsZT0iZm9udC1zaXplOiAyNHB4OyI-PGE-R29vZ2xlIEFQSXMgRXhwbG9yZXI8L2E-IHdhcyBncmFudGVkIGFjY2VzcyB0byB5b3VyIEdvb2dsZSZuYnNwO0FjY291bnQgPC9kaXY-PHRhYmxlIGFsaWduPSJjZW50ZXIiIHN0eWxlPSJtYXJnaW4tdG9wOjhweDsiPjx0ciBzdHlsZT0ibGluZS1oZWlnaHQ6IG5vcm1hbDsiPjx0ZCBhbGlnbj0icmlnaHQiIHN0eWxlPSJwYWRkaW5nLXJpZ2h0OjhweDsiPjxpbWcgd2lkdGg9IjIwIiBoZWlnaHQ9IjIwIiBzdHlsZT0id2lkdGg6IDIwcHg7IGhlaWdodDogMjBweDsgdmVydGljYWwtYWxpZ246IHN1YjsgYm9yZGVyLXJhZGl1czogNTAlOzsiIHNyYz0iaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUFUWEFKenItbXdpcFN3M1owNE8zbWQ4NWV4SXFITjJMZHkxdjZydWxsYTI9czk2IiBhbHQ9IiI-PC90ZD48dGQ-PGEgc3R5bGU9ImZvbnQtZmFtaWx5OiAmIzM5O0dvb2dsZSBTYW5zJiMzOTssUm9ib3RvLFJvYm90b0RyYWZ0LEhlbHZldGljYSxBcmlhbCxzYW5zLXNlcmlmO2NvbG9yOiByZ2JhKDAsMCwwLDAuODcpOyBmb250LXNpemU6IDE0cHg7IGxpbmUtaGVpZ2h0OiAyMHB4OyI-dGVzdGluZ2FjYy5nMDBnbGVAZ21haWwuY29tPC9hPjwvdGQ-PC90cj48L3RhYmxlPiA8L2Rpdj48ZGl2IHN0eWxlPSJmb250LWZhbWlseTogUm9ib3RvLVJlZ3VsYXIsSGVsdmV0aWNhLEFyaWFsLHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgY29sb3I6IHJnYmEoMCwwLDAsMC44Nyk7IGxpbmUtaGVpZ2h0OiAyMHB4O3BhZGRpbmctdG9wOiAyMHB4OyB0ZXh0LWFsaWduOiBsZWZ0OyI-PGJyPklmIHlvdSBkaWQgbm90IGdyYW50IGFjY2VzcywgeW91IHNob3VsZCBjaGVjayB0aGlzIGFjdGl2aXR5IGFuZCBzZWN1cmUgeW91ciBhY2NvdW50LjxkaXYgc3R5bGU9InBhZGRpbmctdG9wOiAzMnB4OyB0ZXh0LWFsaWduOiBjZW50ZXI7Ij48YSBocmVmPSJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vQWNjb3VudENob29zZXI_RW1haWw9dGVzdGluZ2FjYy5nMDBnbGVAZ21haWwuY29tJmFtcDtjb250aW51ZT1odHRwczovL215YWNjb3VudC5nb29nbGUuY29tL2FsZXJ0L250LzE2MjIxODI3NzIwMDA_cmZuJTNEMTI3JTI2cmZuYyUzRDElMjZlaWQlM0Q1MTEyNjQyNDE2MTIzMzY3MzQyJTI2ZXQlM0QwJTI2YW5leHAlM0RucmV0LWZhIiB0YXJnZXQ9Il9ibGFuayIgbGluay1pZD0ibWFpbi1idXR0b24tbGluayIgc3R5bGU9ImZvbnQtZmFtaWx5OiAmIzM5O0dvb2dsZSBTYW5zJiMzOTssUm9ib3RvLFJvYm90b0RyYWZ0LEhlbHZldGljYSxBcmlhbCxzYW5zLXNlcmlmOyBsaW5lLWhlaWdodDogMTZweDsgY29sb3I6ICNmZmZmZmY7IGZvbnQtd2VpZ2h0OiA0MDA7IHRleHQtZGVjb3JhdGlvbjogbm9uZTtmb250LXNpemU6IDE0cHg7ZGlzcGxheTppbmxpbmUtYmxvY2s7cGFkZGluZzogMTBweCAyNHB4O2JhY2tncm91bmQtY29sb3I6ICM0MTg0RjM7IGJvcmRlci1yYWRpdXM6IDVweDsgbWluLXdpZHRoOiA5MHB4OyI-Q2hlY2sgYWN0aXZpdHk8L2E-PC9kaXY-PC9kaXY-PGRpdiBzdHlsZT0icGFkZGluZy10b3A6IDIwcHg7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE2cHg7IGNvbG9yOiAjNWY2MzY4OyBsZXR0ZXItc3BhY2luZzogMC4zcHg7IHRleHQtYWxpZ246IGNlbnRlciI-WW91IGNhbiBhbHNvIHNlZSBzZWN1cml0eSBhY3Rpdml0eSBhdDxicj48YSBzdHlsZT0iY29sb3I6IHJnYmEoMCwgMCwgMCwgMC44Nyk7dGV4dC1kZWNvcmF0aW9uOiBpbmhlcml0OyI-aHR0cHM6Ly9teWFjY291bnQuZ29vZ2xlLmNvbS9ub3RpZmljYXRpb25zPC9hPjwvZGl2PjwvZGl2PjxkaXYgc3R5bGU9InRleHQtYWxpZ246IGxlZnQ7Ij48ZGl2IHN0eWxlPSJmb250LWZhbWlseTogUm9ib3RvLVJlZ3VsYXIsSGVsdmV0aWNhLEFyaWFsLHNhbnMtc2VyaWY7Y29sb3I6IHJnYmEoMCwwLDAsMC41NCk7IGZvbnQtc2l6ZTogMTFweDsgbGluZS1oZWlnaHQ6IDE4cHg7IHBhZGRpbmctdG9wOiAxMnB4OyB0ZXh0LWFsaWduOiBjZW50ZXI7Ij48ZGl2PllvdSByZWNlaXZlZCB0aGlzIGVtYWlsIHRvIGxldCB5b3Uga25vdyBhYm91dCBpbXBvcnRhbnQgY2hhbmdlcyB0byB5b3VyIEdvb2dsZSBBY2NvdW50IGFuZCBzZXJ2aWNlcy48L2Rpdj48ZGl2IHN0eWxlPSJkaXJlY3Rpb246IGx0cjsiPiZjb3B5OyAyMDIxIEdvb2dsZSBMTEMsIDxhIGNsYXNzPSJhZmFsIiBzdHlsZT0iZm9udC1mYW1pbHk6IFJvYm90by1SZWd1bGFyLEhlbHZldGljYSxBcmlhbCxzYW5zLXNlcmlmO2NvbG9yOiByZ2JhKDAsMCwwLDAuNTQpOyBmb250LXNpemU6IDExcHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyBwYWRkaW5nLXRvcDogMTJweDsgdGV4dC1hbGlnbjogY2VudGVyOyI-MTYwMCBBbXBoaXRoZWF0cmUgUGFya3dheSwgTW91bnRhaW4gVmlldywgQ0EgOTQwNDMsIFVTQTwvYT48L2Rpdj48L2Rpdj48L2Rpdj48L3RkPjx0ZCB3aWR0aD0iOCIgc3R5bGU9IndpZHRoOiA4cHg7Ij48L3RkPjwvdHI-PC90YWJsZT48L3RkPjwvdHI-PHRyIGhlaWdodD0iMzIiIHN0eWxlPSJoZWlnaHQ6IDMycHg7Ij48dGQ-PC90ZD48L3RyPjwvdGFibGU-PC9ib2R5PjwvaHRtbD4="
        }
      }
    ]
  },
  "sizeEstimate": 11341,
  "historyId": "4156",
  "internalDate": "1622182772000"
}

{
  "history": [
    {
      "id": "3712",
      "messages": [
        {
          "id": "179b1a0c33d71d2f",
          "threadId": "179b1a0c33d71d2f"
        }
      ],
      "messagesAdded": [
        {
          "message": {
            "id": "179b1a0c33d71d2f",
            "threadId": "179b1a0c33d71d2f",
            "labelIds": [
              "UNREAD",
              "IMPORTANT",
              "CATEGORY_UPDATES",
              "INBOX"
            ]
          }
        }
      ]
    },
    {
      "id": "3875",
      "messages": [
        {
          "id": "179b25ce9d837147",
          "threadId": "179b25ce9d837147"
        }
      ],
      "messagesAdded": [
        {
          "message": {
            "id": "179b25ce9d837147",
            "threadId": "179b25ce9d837147",
            "labelIds": [
              "UNREAD",
              "IMPORTANT",
              "CATEGORY_PERSONAL",
              "INBOX"
            ]
          }
        }
      ]
    }
  ],
  "historyId": "3985"
}
 */
class Tick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue),
    );
  }
}
class PaintTick extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

