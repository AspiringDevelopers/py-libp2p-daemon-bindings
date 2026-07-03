p2pd_pb_path = p2pclient/pb
p2pd_pbs = $(shell find $(p2pd_pb_path) -name *.proto)
pys = $(p2pd_pbs:.proto=_pb2.py)
pyis = $(p2pd_pbs:.proto=_pb2.pyi)

# Set default to `protobufs`, otherwise `format` is called when typing only `make`
all: protobufs

format:
	ruff check --fix p2pclient/ tests/
	ruff format p2pclient/ tests/

lint:
	ruff check p2pclient/ tests/
	ruff format --check p2pclient/ tests/

typecheck:
	mypy -p p2pclient --config-file mypy.ini

test:
	pytest --daemon=p2pd tests/

pr: format lint typecheck test

protobufs: $(pys)

%_pb2.py: %.proto
	protoc --python_out=. --mypy_out=. $<


package:
	# create a source distribution and wheel
	python -m build

.PHONY: clean

clean:
	rm $(pys) $(pyis)

