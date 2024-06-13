---

layout:     post
title:      "Android SFTP Clients Review"
slug:       "android-sftp-clients-review"
date:       2024-06-13 12:43:49
categories: []

---

I've done a quick survey of SFTP clients for Android. Here are my findings.

## Recommendation

My top pick is Owlfiles
- (+)supports a lot of protocols alongside SFTP (e.g. WebDav and S3)
- (+) shows previews of remote files
- (+) supports private keys
- (+) is ascetically pleasing
- (~) It's free(mium), but not very pushy to upgrade
- (-) closed source

## Other contenders

- Termux
  - (+) open source
  - (~) first and foremost a terminal emulator
  - (~) scp is included
  - (-) not particularly friendly for quickly uploading a file
- FTPClient on F-Droid 
  - (+) open source
  - (+) decent UI
  - (-) some features are broken (e.g. renaming a file)
- Terminus
  - (+) very polished
  - (-) closed source
  - (~) first and foremost an SSH client
  - (-) wants you to sign up for a subscription
  - (-) has some odd restrictions about uploading files from the Downloads
    folder

## Discussion

If you have any thoughts or comments, drop a reply in [this mastodon
thread](https://tiny.tilde.website/@kindrobot/112610373065305607).
