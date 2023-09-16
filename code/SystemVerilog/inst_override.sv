`timescale 1ns / 1ps

module test;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class A extends uvm_component;
    `uvm_component_utils(A)
    function new(string name="A", uvm_component parent=null);
      super.new(name, parent);
    endfunction
  endclass

  class B extends uvm_component;
    `uvm_component_utils(B)
    function new(string name="B", uvm_component parent=null);
      super.new(name, parent);
    endfunction
  endclass

  class C extends uvm_component;
    `uvm_component_utils(C)
    function new(string name="C", uvm_component parent=null);
      super.new(name, parent);
    endfunction
  endclass

  class new_type extends C;
    `uvm_component_utils(new_type)
    function new(string name="new_type", uvm_component parent=null);
      super.new(name, parent);
    endfunction
  endclass

  class different_type extends C;
    `uvm_component_utils(different_type)
    function new(string name="different_type", uvm_component parent=null);
      super.new(name, parent);
    endfunction
  endclass

  initial begin
    A a;
    B b;
    C c1, c2, c3;
    // instance overrides
    C::type_id::set_inst_override(different_type::get_type(), "a.b.c2");
    C::type_id::set_inst_override(new_type::get_type(), "a.b.*");

    // component creation
    a = A::type_id::create("a", null);
    b = B::type_id::create("b", a);
    c1 = C::type_id::create("c1", b);
    c2 = C::type_id::create("c2", b);
    c3 = C::type_id::create("c3", b);

    $display("type name of %s : %s", c1.get_full_name(), c1.get_type_name());
    $display("type name of %s : %s", c2.get_full_name(), c2.get_type_name());
    $display("type name of %s : %s", c3.get_full_name(), c3.get_type_name());
  end
endmodule

// -- issues #6 --
