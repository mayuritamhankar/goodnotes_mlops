deploy:
	@make task
	@make test
	@make load-test

task:
	bash scripts/provision_kind_cluster.sh

test:
	@echo "Running tests..."
	sleep 30 # Wait for the cluster to be ready
	curl -H "Host: foo.localhost" http://localhost/
	curl -H "Host: bar.localhost" http://localhost/

load-test:
	bash scripts/load_test.sh
