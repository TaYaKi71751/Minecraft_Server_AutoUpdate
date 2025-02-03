#!/bin/bash
ORIGIN_PWD="$PWD"
while true
do
 SERVER_PIDS="$(ps ax | grep server.jar | cut -d ' ' -f1)"
	while IFS= read -r SERVER_PID
	do
		kill -9 $SERVER_PID
	done < <(printf '%s\n' "${SERVER_PIDS}")
	cd "${ORIGIN_PWD}/world"
	git add -A
	git commit -m "$(date +%s)"
	git push
	cd "${ORIGIN_PWD}"
	rm server.jar
	JAR_URL="$(curl --http1.1 -A "Mozilla/5.0" -LsSf "https://www.minecraft.net/en-us/download/server" | grep server.jar | rev | cut -d '"' -f4 | rev)"
	echo $JAR_URL
	curl --http1.1 -A "Mozilla/5.0" -LsSf "${JAR_URL}" -o server.jar
	echo "eula=true" > eula.txt
	java -jar server.jar --nogui &
	sleep 3600
done
