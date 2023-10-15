up:
	 docker compose -f docker-compose.yaml up -d --build
exec_root:
	docker exec -it mpi_app bash
exec_no_root:
	docker exec -it  --user no_root mpi_app bash