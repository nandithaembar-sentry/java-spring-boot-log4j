# Must have `sentry-cli` installed globally
# Following variable must be passed in
SENTRY_AUTH_TOKEN=4d72bbc9473c4b40891d662836a1678209e361cec803409abd25f68ad0c6f276

SENTRY_ORG=testorg-az
SENTRY_PROJECT=nanditha-java
VERSION=`sentry-cli releases propose-version`

deploy: setup_release run_jar

setup_release: create_release associate_commits

create_release:
	sentry-cli releases -o $(SENTRY_ORG) new -p $(SENTRY_PROJECT) $(VERSION)

associate_commits:
	sentry-cli releases -o $(SENTRY_ORG) -p $(SENTRY_PROJECT) set-commits --auto $(VERSION)

run_jar:
	mvn clean package && \
	 java -agentpath:libsentry_agent.dylib -Dsentry.release=$(VERSION) -jar target/sentry-spring-boot-log4j2-example-0.0.1.jar
