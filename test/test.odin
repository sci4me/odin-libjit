package libjittest

import "core:fmt"

import lj "shared:odin-libjit"

main :: proc() {
    lj.init();
    
    ctx := lj.context_create();
    defer lj.context_destroy(ctx);

    lj.context_build_start(ctx);

    params := []lj.Type{lj.type_int, lj.type_int};
    signature := lj.type_create_signature(.Cdecl, lj.type_int, &params[0], 2, 1);
    defer lj.type_free(signature);
    fn := lj.function_create(ctx, signature);

    a := lj.value_get_param(fn, 0);
    b := lj.value_get_param(fn, 1);
    c := lj.insn_add(fn, a, b);
    lj.insn_return(fn, c);

    lj.function_compile(fn);
    lj.context_build_end(ctx);

    add := transmute(proc(a, b: i32) -> i32) lj.function_to_closure(fn);

    fmt.println(add(4, 2));
}