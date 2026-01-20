CORE_GEM_NAME := uwo_bot_core
LAMBDA_GEM_NAME := uwo_bot_lambda
VENDOR_PATH := vendor/bundle/ruby/3.4.0

package_for_lambda:
	rm -rf vendor/*
	for g in $(CORE_GEM_NAME) $(LAMBDA_GEM_NAME); do \
		gem build ../$$g/$$g.gemspec -C ../$$g -o $$(pwd)/pkg/$$g.gem; \
		gem install $$(pwd)/pkg/$$g.gem -N -f -i $(VENDOR_PATH); \
	done
	zip -q -r pkg/bot-$$(date +%Y%m%d%H%M%S).zip \
		main.rb \
		vendor
