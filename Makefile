database:
	cd database
	SHA1=`git rev-parse --short HEAD`
	export DB_VERSION="1.0.0-$SHA1"
	docker build . --tag bmoussaud/bookstore-advanced-database:$DB_VERSION --build-arg version=$DB_VERSION
	docker tag bmoussaud/bookstore-advanced-database:$DB_VERSION registry.local:5000/bmoussaud/bookstore-advanced-database:$DB_VERSION
	docker push registry.local:5000/bmoussaud/bookstore-advanced-database:$DB_VERSION
	cd -
web:
	SHA1=`git rev-parse --short HEAD`
	mvn package -B -Dcontainer.image.name="bmoussaud/bookstore-advanced" -Dcontainer.image.registry="registry.local:5000" -Dsha1="-${SHA1}"

exportci:
	./xlw --config config.yaml generate xl-deploy -s -p Configuration -f xebialabs/configuration.yaml
	./xlw --config config.yaml generate xl-deploy -s -p Applications -f xebialabs/applications.yaml
	./xlw --config config.yaml generate xl-deploy -s -p Infrastructure -f xebialabs/infrastructure.yaml
	./xlw --config config.yaml generate xl-deploy -s -p Environments -f xebialabs/environments.yaml


importci:
	./xlw --config config.yaml apply -f xebialabs/configuration.yaml
	./xlw --config config.yaml apply -f xebialabs/applications.yaml
	./xlw --config config.yaml apply -f xebialabs/infrastructure.yaml
	./xlw --config config.yaml apply -f xebialabs/environments.yaml