---

layout:     post 
title:      "phpBB in Docker with SMTP backed sendmail"
slug:       "phpbb-docker"
date:       2024-11-02 18:26:27 
categories: [linux]

---

phpBB3 is a forum software written, appropriately enough, in php. It's a
nostalgic piece of software for us because I ran a phpbb forum for our high
school friends.  The tilde.town community has been chatting about standing up
2000's era forum software, some folks even going so far as to start writing
their own forum software.

We didn't win the tilde.town phpbb space race. [dzwzd](https://tilde.town/~dzwdz)
and a group of townies stood up https://forum.sickos.net. The folks working on
it have an idea of what kind of community they want to build and how they want
to modify their instance either with skins, extensions, and custom CSS. We do not
have such lofty ambitions. We stood up https://tilde.fans/ with minimal changes,
even in the settings. The biggest challenge for us was that we did not want to
install apache on our machine, and we did not want to have to worry about security
vulnerabilities in php and phpbb. The natural tools to use in 2024 is
containerization, and php applications are especially good candidates for
containerization. They have a lot of system dependencies that can be vendored
into a (docker) container for instance. This blog post steps through the steps we 
took to containerize phpbb from scratch.

## tl;dr use it yourself

If you'd like to run this yourself, we recommend using docker compose which can
build the phpbb container image, configure, and deploy both the phpbb container
and a mysql container.

```
git clone https://github.com/kindrowboat/phpbb3-docker
cd phpbb3-docker
cp .env.example .env
# fill in .env file
./clean-install.sh
sudo docker-compose build
sudo docker-compose up -d
```

Check the logs with `sudo docker-compose logs -f phpbb`. Visit your site at
http://localhost:6862. We recommend putting it behind a reverse proxy, like
[Caddy](https://caddyserver.com).

## Prior Art

We're not the first one's to containerize phpbb. Bitnami historically released a
phpbb Docker container and helm chart, however, these were archived and removed
from their containers repo. You can of course, go back in the git history and
view the old [bitnami Dockerfile]. However you'll quickly notice that it depends
on bitnami's build assets, which they will of course, will no longer be
producing. We looked around for other solutions, and could find anything actively
maintained, so we decided to take a crack at it as an exercise.

[bitnami Dockerfile]: https://github.com/bitnami/containers/blob/29ca184c34c1918d14fe468b27bcc16fae79572f/bitnami/phpbb/3/debian-12/Dockerfile

## Challenges

There's always a bit of kajiggering involved when Dockerizing a lamp stack. Get
the Apache config, php config, modules for both, requisite packages, and folder
permissions. There's no advice we can give here if you're not an apache and/or
php person (we are not). Lots of Googling, reading READMEs, and consulting an
LLM got us to stumble into the right concoction. We made the conscious decision
to have the phpbb files as a mounted volume into the container. This is because
state is stored there, and sometimes you have to edit those files. That state
and those changes would be at risk of evaporating if the container had to be
restarted.

This left the remaining challenge: e-mail. We wanted the [tilde.fans] to be
e-mail sign up to prevent _some_ spam bots from the board. phpBB uses two
methods to send mail: sendmail or SMTP. We should've been able to get sendmail
to work, sending the email straight from the docker container. This didn't work
for some reason, and even if it did, the email would've almost certainly been
sent to the recipients spam folder because it's from a VPS floating IP. So then
we tried to configure SMTP from the phpBB admin interface, but for some reason
we couldn't find joy there either. We think that [migadu](https://migadu.com)
probably had some required setting that couldn't be set in phpBB. We had one
final idea: use an SMTP client that we were familiar with from our emacs days,
msmtp. We knew it could be used in place of the default Debian sendmail, and we
knew we from experience how to configure it with migadu's SMTP server. This
worked like a charm, and we were content.

We used a custom entry point because:

1. we needed ownership to be set at runtime on the mount phpBB files
1. we wanted configuration set through environment variables when starting the
   container to be marshalled into configuration files for msmtp

### Reverse proxy setting

We set up caddy to reverse proxy into localhost:6862 (where the container was
listening). It was dead simple:

```
https://tilde.fans:443 {
        reverse_proxy localhost:6862
}
```

## Conclusion

This was a fun project. It's nice to find practical uses for skills you learn at
work. ;) The code is at https://github.com/kindrowboat/phpbb3-docker. There is a
public container image on dockerhub: [kindrobot/phpbb3:3.3]. Though we recommend
building it yourself and run it using (docker-compose)[https://docs.docker.com/compose/]
using the instructions at the top. We plan to keep maintaining this image as
long as [tilde.fans] is a thing.  Comments, issues, and pull requests welcome.
You're welcome to leave comments [on mastodon](https://tiny.tilde.website/@kindrobot/113417271593163796).

[kindrobot/phpbb3:3.3]: https://hub.docker.com/repository/docker/kindrobot/phpbb3/general
[tilde.fans]: https://tilde.fans/