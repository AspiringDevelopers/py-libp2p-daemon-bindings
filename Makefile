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
	mypy -p p2pclient

test:
	pytest --daemon=p2pd tests/

tox:
	tox

pr: format lint typecheck test tox

protobufs: $(pys)

%_pb2.py: %.proto
	protoc --python_out=. --mypy_out=. $<


dist:
	# create a source distribution and wheel
	python -m build

setup:
	pip install -e .[dev]

help:
	@echo "Available targets:"
	@echo "  help      - display this help message"
	@echo "  setup     - install dependencies"
	@echo "  format    - format code"
	@echo "  lint      - run linters"
	@echo "  typecheck - run type checker"
	@echo "  test      - run tests"
	@echo "  tox       - run tests and typechecks across multiple environments using tox"
	@echo "  pr        - run format, lint, typecheck, test, tox"
	@echo "  protobufs - compile protobufs"
	@echo "  dist      - create a source distribution and wheel"
	@echo "  clean     - clean generated files"

.PHONY: clean

clean:
	rm $(pys) $(pyis)

