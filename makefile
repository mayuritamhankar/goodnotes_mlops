deploy:
	@make task
	@make load-test

task:
	bash scripts/provision_kind_cluster.sh

load-test:
	bash scripts/load_test.sh
	