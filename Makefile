SCRBL := raco scribble --htmls ++main-xref-in --redirect-main http://docs.racket-lang.org/

OUT_DIR := doc_build
$(OUT_DIR):
	@mkdir $(OUT_DIR)

.PHONY: build publish test
build: $(OUT_DIR)
	@$(SCRBL) --dest $(OUT_DIR) scribblings/k.scrbl

test:
	@raco test .

clean:
	@rm -r $(OUT_DIR)
