# Run the mysql container standalone

docker container run -v "//c/Users/javier/Google Drive/dev/python/Checklist/docker:/root/Checklist" MYSQL_ROOT_PASSWORD=Feb_2008 -w /root --name checklistdb -it mysql
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

# Run the service

docker stack deploy --compose-file stack.yml checklist

# SH into a container

docker container exec -it checklist_api.1.ulcshtigypixbgjrtrsf2ji2d bash

# Show logs for service

docker service logs checklist_api

# Start the stack in the docker swarm with K8S enabled in Docker Engine

docker stack --orchestrator swarm deploy --compose-file stack.yml checklist

# Stop the stack

docker stack --orchestrator swarm rm checklist

# Push images to ducker hub

docker tag <image> jimenj1970/<image>
docker login -u jimenj1970
docker push jimenj1970/<image>

docker tag checklist-api jimenj1970/checklist-api
docker push jimenj1970/checklist-api

# K8s connect to pod shell

kubectl exec --stdin --tty ui-86ccfc7f87-57f2x -- /bin/bash

# K8s ingress controller installation

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/cloud/deploy.yaml --namespace ingress-nginx

# Run the puppet-master container
docker run -d -it -p 8140:8140 --rm --name puppet-master ubuntu
	sudo apt-get update
	sudo apt-get install wget
	wget https://apt.puppetlabs.com/puppet-release-bionic.deb
	sudo dpkg -i puppet-release-bionic.deb
	sudo apt-get install puppetmaster
	apt policy puppetmaster
	sudo systemctl status puppet-master.service
	vim /etc/default/puppet-master -- JAVA_ARGS="-Xms512m -Xmx512m"
	sudo systemctl restart puppet-master.service
	sudo ufw allow 8140/tcp

	// change code
	sudo mkdir -p /etc/puppet/code/environments/production/manifests/
	sudo nano /etc/puppet/code/environments/production/manifests/site.pp
	file {'/tmp/it_works.txt':				# resource type file and filename
	  ensure  => present,					# make sure it exists
	  mode    => '0644',					# file permissions
	  content => "It works on ${ipaddress_eth0}!\n",	# print the eth0 IP fact
	}

	sudo systemctl restart puppet-master

# Run the puppet-slave container
docker run -d -it --rm --name puppet-slave ubuntu
	sudo apt-get update
	sudo apt-get install wget
	wget https://apt.puppetlabs.com/puppet-release-bionic.deb
	sudo dpkg -i puppet-release-bionic.deb
	sudo apt-get install puppet

	sudo systemctl start puppet
	sudo systemctl enable puppet

	apt-get install vim
	apt-get install iproute2

# Connect puppet slave to master
	# on master
	sudo puppet cert list # shows puppet agent certs awaiting signing
	sudo puppet cert sign --all # signs all awaiting puppet agent certs

	# on agent
	sudo puppet agent --test

# Run the ansible container
	docker run -d -it --rm --name ansible ubuntu
	docker container exec-it ansible bash
	sudo apt-get update
	sudo apt-get install vim
	apt-get install ssh
	ssh-keygen -t rsa
	sudo apt-get install ansible
	mkdir ansible
	vi  play.yaml
	---                                  
                                     
	 - hosts: slave1                      
	   sudo: yes                         
	   name: play1                       
	   tasks:                            
	    - name: Install Apache           
	      apt: name=apache2 state=latest 
	    - name: Start Apache            
	      command: service apache2 start
	 - hosts: slave2                      
	   sudo: yes                         
	   name: play1                       
	   tasks:                            
	    - name: Install Nginx           
	      apt: name=nginx state=latest 
	    - name: Start Nginx
	      command: service nginx start

# Run the ansible slave
	docker run -d -it -p 8005:80 --rm --name ansible-slave-1 ubuntu
	docker container exec -it ansible-slave-1 bash
		apt-get update
		apt-get install vim
		apt-get install python
		apt-get install iproute2
		apt-get install ssh
		vi /etc/ssh/sshd_config -- PermitRootLogin yes
		service ssh start          

	# On master
		ssh-copy-id root@172.17.0.5
		vi /etc/ansible/hosts -- slave1 ansible_ssh_host=172.17.0.5
		ansible -m ping all
		ansible-playbook play.yaml

			---                                                  
                                                     
			 - hosts: slave1 slave3 slave4                       
			   name: play1                                       
			   tasks:                                            
			    - name: Install nginx                            
			      apt: name=nginx state=latest                   
			    - name: Start service nginx, if not started      
			      service:                                       
			         name: nginx                                 
			         state: started                              
			 - hosts: slave2                                     
			   name: play1                                       
			   tasks:                                            
			    - name: Install Java                             
			      apt: name=oracle-jave8-installer state=latest  
			    - name: Install Java                             
			      apt: name=oracle-jave8-set-default state=latest
 			   - name: Install docker                           
 			     apt: name=docker.io state=latest               

# Run Jenkins server 
	docker run -d -p 8081:8080 -p 50000:50000 --name jenkins -v jenkins_home:/var/jenkins_home jenkins/jenkins

	setup slave nodes in jenkins console at http://checklist.local:8081

# Run Jenkins slaves
	docker run -d --name jenkins-slave-1 --init jenkins/inbound-agent -url http://checklist.local:8081 -workDir=/home/jenkins/agent 273a4254bb1d1d1e72fdd62fa0baefa7025d5870df152f6d5b106d7645f4a41a slave-1
	docker run -d --name jenkins-slave-2 --init jenkins/inbound-agent -url http://checklist.local:8081 -workDir=/home/jenkins/agent c76137fa327ccf66cc8aa6e972e894b0d9964afe78059e74f3b0ae4131b96137 slave-2
	