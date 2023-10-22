CXX = em++
EXE = stockfishWeb

OPT ?= -O3 --closure=1 # make OPT="-O0 -g3 -DDEBUG -sASSERTIONS=2 -sSAFE_HEAP -gsource-map"

CXX_FLAGS = $(OPT) -Isrc -Isrc/wasm -pthread -msse -msse2 -mssse3 -msse4.1 -msimd128 \
	-DIS_64BIT -DUSE_SSE2 -DUSE_SSSE3 -DUSE_SSE41 -DUSE_POPCNT -DNNUE_EMBEDDING_OFF -DNO_PREFETCH \
	-fno-exceptions -flto

LD_FLAGS = $(CXX_FLAGS)  --pre-js=src/wasm/initModule.js -sEXPORT_ES6 -sEXPORT_NAME=StockfishWeb \
	-sEXPORTED_FUNCTIONS='[_malloc]' -sEXPORTED_RUNTIME_METHODS='[stringToUTF8,UTF8ToString]' \
	-sINCOMING_MODULE_JS_API='[locateFile,print,printErr,wasmMemory,buffer,instantiateWasm]' \
	-sINITIAL_MEMORY=64MB -sALLOW_MEMORY_GROWTH -sSTACK_SIZE=2MB -sWASM_BIGINT -sFILESYSTEM=0 \
	-sALLOW_BLOCKING_ON_MAIN_THREAD=0 -sPTHREAD_POOL_SIZE=navigator.hardwareConcurrency \
	-sPROXY_TO_PTHREAD -sSTRICT -sMODULARIZE 

SOURCES = bitbase.cpp bitboard.cpp benchmark.cpp endgame.cpp evaluate.cpp main.cpp material.cpp \
	misc.cpp movegen.cpp movepick.cpp pawns.cpp position.cpp psqt.cpp search.cpp thread.cpp \
	timeman.cpp tt.cpp tune.cpp uci.cpp ucioption.cpp nnue/evaluate_nnue.cpp \
	nnue/features/half_ka_v2_hm.cpp wasm/glue.cpp wasm/wasm_simd.cpp

OBJS = $(addprefix src/, $(SOURCES:.cpp=.o))

.PHONY: build node clean

build: ENVIRONMENT = web,worker
build: $(EXE)

node: ENVIRONMENT = node
node: $(EXE)
	@cat src/wasm/createRequire.js $(EXE).worker.js > $(EXE).worker.js.tmp
	@mv $(EXE).worker.js.tmp $(EXE).worker.js

$(EXE): $(OBJS)
	$(CXX) -o $@.js $(OBJS) $(LD_FLAGS) -sENVIRONMENT=$(ENVIRONMENT)

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c $< -o $@

clean:
	@rm -f $(OBJS) $(EXE).js $(EXE).wasm* $(EXE).worker.js
