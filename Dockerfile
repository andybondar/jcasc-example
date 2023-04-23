FROM jenkins/jenkins:2.401
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY jcasc/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt