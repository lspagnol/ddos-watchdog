# ddos-watchdog

DDOS Watchdog est un démon destiné à protéger les serveurs des attaques DDOS basées sur des requêtes valides et anodines.

# Principe de fonctionnement:
- Démarrage du démon: téléchargement et mise à jour de listes blanches (blocs d'adresses IPv4 et IPv6)
  - l'activité du démon est consignée dans syslog (syslog-tag *ddos-watchdog*)
- Mise en place d'un lien symbolique vers le fichier de logs à surveiller
- Si le nombre de lignes dépasse le seuil autorisé sur la période définie:
  - des règles Netfilter sont insérées pour n'autoriser que le trafic provenant du LAN et des listes blanches,
  - le déblocage automatique est planifié,
  - un mail d'alerte est envoyé.

# Installation
```
git clone https://github.com/lspagnol/ddos-watchdog
cd ddos-watchdog
bash install.sh
```
Pour activer le démon au démarrage du serveur:
```
update-rc.d -f ddos-watchdog defaults
```

# Configuration
Editer le fichier */usr/local/ddos-watchdog/etc/ddos-watchdog.conf*:
```
# Fichier de logs à surveiller
LOG_FILE=/var/log/nginx/access.log

# FACULTATIF: regexp de filtrage des logs (attention simple-quotes obligatoire)
#FILTER='^.* HTTP/(1|2)\.(0|1)" 403 '

###################################################################
# Configuration de l'analyse et du blocage

# Délai d'attente entre deux analyses (secondes)
PERIOD=10

# Nombre max de connexions pendant la période
TRIGGER=2000

# Durée du blocage (minutes)
BLOCKING_DURATION=30

# Activer le blocage pour ces protocoles
ENABLE_IPV4=1
ENABLE_IPV6=1

###################################################################
# Définition des blocs d'adresses en liste blanche

# URL de téléchargement des blocs d'adresses IPv4
DL_URL_IPV4='https://www.ipdeny.com/ipblocks/data/countries/fr.zone'

# Blocs IPv4 à ajouter à la liste
LAN_IPV4="10.0.0.0/8"

# URL de téléchargement des blocs d'adresses IPv6
DL_URL_IPV6='https://www.ipdeny.com/ipv6/ipaddresses/blocks/fr.zone'

# Blocs IPv6 à ajouter à la liste
LAN_IPV6="fe80::/10"

###################################################################
# Divers

# Destinataires mail d'alerte
MAIL_DESTS="dest1@domaine1.fr dest2@domaine2.fr"

# Mode DEBUG
# 0: fonctionnement normal
# 1: alerte mail uniquement, pas de mise en place du blocage
# 2: pas d'alerte mail ni de blocage (permet de surveiller l'activité dans Syslog)
DEBUG=0
```

# Tester la configuration:
```ddos-watchdog test```
