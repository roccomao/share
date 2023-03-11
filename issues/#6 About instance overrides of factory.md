
1. Like type overrides, instance overrides should precede object creation.

   - All factory overrides code should be executed in a parent prior to building the children. This means that environment overrides should be specified in the test.

2. Instance overrides : The `full_inst_path` may include wildcards (`*` and `?`) such that a single instance override can be applied in multiple contexts. A `full_inst_path` of `*` is effectively a type override, as it will match all contexts.

3. When the factory processes instance overrides, the instance queue is processed in order of override registrations, and the first override match prevails. Thus, more specific overrides should be registered first, followed by more general overrides.

4. Instance overrides are used in a first-match order. For each component, the first applicable instance override is used when the environment is constructed. If no instance overrides are found, then the type overrides are searched for any applicable type overrides. The ordering of the instance overrides in your code affects the application of the instance overrides. For example:

   ```verilog
   my_type::type_id::set_inst_override(new_type::get_type(), "a.b.*");
   my_type::type_id::set_inst_override(different_type::get_type(), "a.b.c");
   ```

   All of the objects under `a.b` will get `new_type` and the instance override `a.b.c` is ignored. You should execute more-specific instance overrides first, as follows:

   ```verilog
   my_type::type_id::set_inst_override(different_type::get_type(), "a.b.c");
   my_type::type_id::set_inst_override(new_type::get_type(), "a.b.*");
   ```

   This will create `a.b.c` with `different_type`, and all other objects under `a.b` of `my_type` are created using `new_type`.

--------

**NOTE**: The fourth point above is excerpted from section **6.2.3.2** *Instance Overrides* of document ***UVM 1.x User's Guide***, but the sample code of the original document is reversed and corrected here.

- Demo Code: [inst_override.sv](../code/SystemVerilog/inst_override.sv)
- Reference: [UVM 1.2 Class Reference](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/)

<!-- ../blob/master -->
