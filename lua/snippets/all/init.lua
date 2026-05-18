local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function simple(trig, body)
  return s(trig, t(vim.split(body, '\n', { plain = true })))
end

return {
  simple(
    'cmake',
    [[
cmake_minimum_required(VERSION 3.12)
project(my_project LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(app main.cpp)]]
  ),
  simple(
    'gnuplot',
    [[// NOTE: popen opens a program according to POSIX specs
FILE* gnuPipe = popen("gnuplot -persistent", "w");
if (gnuPipe == NULL) {
  perror("popen");
  return 1;
}
// WSLg: 'set terminal wxt persist' is needed so the window survives pclose.
// '-persistent' alone is unreliable when the wxt backend isn't warm yet.
fprintf(gnuPipe, "set terminal wxt persist\n");
fprintf(gnuPipe, "set title 'demo'\n");
fprintf(gnuPipe, "plot '-' with linespoints\n");
for (int i = 0; i < 10; ++i) {
  fprintf(gnuPipe, "%d %d\n", i, i * i);
}
fprintf(gnuPipe, "e\n");
fflush(gnuPipe);
pclose(gnuPipe);]]
  ),
  simple(
    'bitflag',
    [[enum class Flags : uint32_t {
    NONE = 0,
    A    = 1 << 0,
    B    = 1 << 1,
    C    = 1 << 2,
};

constexpr Flags operator|(Flags lhs, Flags rhs) noexcept {
    return static_cast<Flags>(static_cast<uint32_t>(lhs) | static_cast<uint32_t>(rhs));
}
constexpr Flags operator&(Flags lhs, Flags rhs) noexcept {
    return static_cast<Flags>(static_cast<uint32_t>(lhs) & static_cast<uint32_t>(rhs));
}
constexpr Flags operator^(Flags lhs, Flags rhs) noexcept {
    return static_cast<Flags>(static_cast<uint32_t>(lhs) ^ static_cast<uint32_t>(rhs));
}
constexpr Flags operator~(Flags f) noexcept {
    return static_cast<Flags>(~static_cast<uint32_t>(f));
}
inline Flags& operator|=(Flags& lhs, Flags rhs) noexcept { return lhs = lhs | rhs; }
inline Flags& operator&=(Flags& lhs, Flags rhs) noexcept { return lhs = lhs & rhs; }
inline Flags& operator^=(Flags& lhs, Flags rhs) noexcept { return lhs = lhs ^ rhs; }

constexpr bool has_flag(Flags f, Flags bit) noexcept {
    return (f & bit) != Flags::NONE;
}

// Flags f = Flags::NONE;
// f |= Flags::A;                  // set
// f &= ~Flags::A;                 // clear
// f ^= Flags::A;                  // toggle
// if (has_flag(f, Flags::A)) {}   // check
]]
  ),

  -- GAMSPy snippets
  simple(
    'import_gamspy',
    [[import pandas as pd
import sys
import numpy as np
from gamspy import Container, Set, Parameter, Variable, Equation, Model, Sum, Sense, Options]]
  ),

  s('set', {
    i(1, 'set_name'),
    t { ' = Set(', '    container = ' },
    i(2, 'm'),
    t { ',# use your container name', '    name = "' },
    i(3, 'set_name'),
    t { '",', '    description = "' },
    i(4, 'description'),
    t { '",', '    records = ' },
    i(5, 'records'),
    t { ' # Enter like: ["Chicken", "Beef", "Eggs", "Milk"]', ')' },
  }),

  s('parameter', {
    i(1, 'parameter_name'),
    t { ' = Parameter(', '    container = ' },
    i(2, 'm'),
    t { ', # use your container name', '    name = "' },
    i(3, 'parameter_name'),
    t { '",', '    description = "' },
    i(4, 'description'),
    t { '",', '    domain = ' },
    i(5, 'set_name'),
    t { ', # Enter the name of the set, where it should apply to each member of.', '    records = ' },
    i(6, 'records'),
    t { ' # Enter like this: [["Yellow", "Giraffe", 4], ["Brown", "Bear", 10]]', ')' },
  }),

  s('variable', {
    i(1, 'variable_name'),
    t { ' = Variable(', '    container = ' },
    i(2, 'm'),
    t { ', #use your container name', '    name = "' },
    i(3, 'variable_name'),
    t { '",', '    domain = ' },
    i(4, 'set_name'),
    t { ',  # Enter the name of the set, where it should apply to each member of.', '    type = "' },
    i(5, 'type'),
    t { '", # e.g. "Positive"', '    description = "' },
    i(6, 'description'),
    t { '"', ')' },
  }),

  s('equation', {
    i(1, 'equation_name'),
    t { ' = Equation(', '    container = ' },
    i(2, 'm'),
    t { ', # use your container name', '    name = "' },
    i(3, 'equation_name'),
    t { '",', '    description = "' },
    i(4, 'please describe what it does'),
    t { '",', '    domain = ' },
    i(5, 'set_name'),
    t { ', # Enter the name of the set, where it should apply to each member of.', '    definition = ' },
    i(6, 'enter equation'),
    t { " # Enter the equation with '==', '<=', '>='", ')' },
  }),

  s('model', {
    i(1, 'model_name'),
    t { ' = Model(', '    container = ' },
    i(2, 'm'),
    t { ', # use your container name,', '    name = "' },
    i(3, 'model_name'),
    t { '",', '    equations = ' },
    i(4, 'm'),
    t { '.getEquations(),', '    problem = "' },
    i(5, 'TYPE'),
    t { '", # could be LP, NLP, MIP, MINLP', '    sense = Sense.' },
    i(6, 'sense'),
    t { ', # Either: MIN or MAX', '    objective = ' },
    i(7, 'obj_func'),
    t { ' # Enter the var. name of objective function', ')' },
  }),

  s('solve', {
    i(1, 'model_name'),
    t { '.solve(', '    output = ' },
    i(2, 'sys.stdout'),
    t { ',', '    options = Options(', '        equation_listing_limit = ' },
    i(3, '50'),
    t { ',', '        variable_listing_limit = ' },
    i(4, '50'),
    t { '', '    )', ')' },
  }),

  simple(
    'GAMS_Template',
    [[import pandas as pd
import sys
import pdflatex
import numpy as np
from gamspy import Container, Set, Parameter, Variable, Equation, Model, Sum, Sense, Options

# Initialize Container
m = Container()

# 1. Define Sets
# Hint: type 'set' and use autocomplete

# 2. Define Parameters
# Hint: type 'parameter' and use autocomplete
# Hint: Use print(var_name.records) to verify parameter data.

# 3. Define Variables
# Hint: type 'variable' and use autocomplete

# 4. Define Constraints (Equations)
# Hint: type 'equation' and use autocomplete

# 5. Define Objective Function
# Example:
# cost_obj = Sum((domain_1, domain_2), j[domain_1, domain_2] * costs[domain_1])
# Hint: No domain mention also careful: () != []

# 6. Create and Solve the Model
# Hint: type 'model' and use autocomplete

# Hint: type 'solve' and use autocomplete

# 7. Print Results
# Example:
# print(model_name.getVariableListing())
# print(f"Optimal Cost: {model_name.objective_value}")

# model_name.toLatex(path="EnterPathHere", generate_pdf=False)

# Generate GAMS File using:
# model_name.toGams(path="EnterPathHere")
#print(f"Optimal Cost: {model_name.objective_value}")
#print('========VARIABLES==========')
#for var in m.getVariables():
#   print(var.name)
#   print(var.records)
#print('========EQUATIONS==========')
#
#for eq in m.getEquations():
#   print(eq.name, eq.description)
#   print(eq.records)]]
  ),

  s('Class', {
    t 'class ',
    i(1, 'ClassName'),
    t { ':', '    """', '    ' },
    i(2, 'Class Description'),
    t { '', '    """', '', '    def __init__(self, ' },
    i(3, 'arg1'),
    t ', ',
    i(4, 'arg2'),
    t { '):', '        self.' },
    i(5, 'arg1'),
    t ' = ',
    i(6, 'arg1'),
    t { '', '        self.' },
    i(7, 'arg2'),
    t ' = ',
    i(8, 'arg2'),
    t { '', '', '    @classmethod', '    def ' },
    i(9, 'class_method'),
    t '(cls, ',
    i(10, 'args'),
    t { '):', '        """', '        ' },
    i(11, 'Description of the class method'),
    t { '.', '        """', '        ' },
    i(12, '# Write class method logic here'),
  }),
}
