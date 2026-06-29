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
cmake_minimum_required(VERSION 3.15...4.1)
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
  simple(
    'cmake_commented_l1',
    [[
cmake_minimum_required(VERSION 3.15...4.1)
project(Calculator LANGUAGES CXX)

# calclib: target's name (handle for within this file to refer to)
# STATIC: makes .a file (if SHARED then .so, if INTERFACE it produces nothing,
# as this indicates we have a header only library)
# src/calclib.cpp: the source file being compiled into the library
# include/calc/lib.hpp: only for IDE referencing, no code functionality
# NOTE: The file will appear as libcalclib.a inside /build, as prefix "lib"
# is added by CMake, as well as .a on linux systems
add_library(calclib STATIC src/calclib.cpp include/calc/lib.hpp)

# include contains the .hpp headers needed to satisfy the compiler at
# compilation time. When calclibs source files (src/calclib.cpp) get compiled
# the headers are made available via -I include/ (this would also be the case
# with PRIVATE)
# Due to keyword PUBLIC, the headers in calclib are also made available with -I
# include/ to any *target* within this call of *cmake* that links against 
# libcalclib.a
target_include_directories(calclib PUBLIC include)

# indicates that the source files that are part of *target* library calclib,
# later libcalclib.a need to be compiled according to C++11 standard.
# PUBLIC: means any target linking against libcalclib.a also needs to be
# compiled under C++11 standards or higher.
target_compile_features(calclib PUBLIC cxx_std_11)

# produces the executable named calc to be run via ./calc from /build folder
add_executable(calc apps/calc.cpp)

# ensures that calc executable get's linked against libcalclib.a
# PRIVATE: almost redundant as nothing ever really links against an executable
# (calc) anyhow.
target_link_libraries(calc PRIVATE calclib)]]
  ),
  simple(
    'cmake_for_sharing_v1',
    [[
# =============================================================================
# Reusable template: an installable + exportable C++ library.
#
# INTENDED USE CASE
# -----------------
# You wrote a library and want OTHER projects (on this or another machine) to
# consume it via the standard:
#
#       find_package(my_custom_proj_name 1.0 REQUIRED)
#       target_link_libraries(myapp PRIVATE my_custom_proj_name::my_custom_proj_name)
#
# After `cmake --install`, the headers land in <prefix>/include, the compiled
# library in <prefix>/lib, and a CMake "package" (Config + Version + Targets
# files) in <prefix>/lib/cmake/<name>/ so find_package() can locate everything.
# Default <prefix> is /usr/local; override with `cmake --install build --prefix /foo`.
#
# EXPECTED LAYOUT
# -----------------
#   my_custom_proj_name/
#   ├── CMakeLists.txt                                  <- this file
#   ├── cmake/my_custom_proj_nameConfig.cmake.in       <- the .in file (bottom of this file)
#   ├── include/my_custom_proj_name/my_custom_proj_name.hpp
#   └── src/my_custom_proj_name.cpp
#
# REUSE: replace `my_custom_proj_name` everywhere. Three strings must match:
#   (1) the project/target name, (2) the `::` namespace, (3) the
#   Targets/Config/ConfigVersion filename prefixes. The src/ and include/ paths
#   you tweak per project.
# =============================================================================

# Require at least CMake 3.23 (FILE_SET HEADERS, used below, needs 3.23).
cmake_minimum_required(VERSION 3.23)

# Declare the project. VERSION feeds the version-compat check later; LANGUAGES
# CXX = C++ only (skips CMake's C-compiler probing).
project(my_custom_proj_name VERSION 1.0 LANGUAGES CXX)

# include() pulls in CMake-provided modules (scripts of helper commands):
#   GNUInstallDirs           -> defines CMAKE_INSTALL_LIBDIR / _INCLUDEDIR / _BINDIR
#                               (e.g. "lib", "include") so destinations are portable.
#   CMakePackageConfigHelpers -> provides configure_package_config_file() and
#                               write_basic_package_version_file() used below.
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Define the library target from its source(s). No STATIC/SHARED keyword => the
# kind follows BUILD_SHARED_LIBS (default OFF => static .a). Let the consumer
# decide via -DBUILD_SHARED_LIBS=ON.
add_library(my_custom_proj_name src/my_custom_proj_name.cpp)

# A second, `::`-style name for the SAME target. Lets us (and consumers) always
# write the namespaced form; a `::` name must resolve to a real target, so
# typos fail at configure time instead of becoming a bad -l flag at link time.
add_library(my_custom_proj_name::my_custom_proj_name ALIAS my_custom_proj_name)

# Require C++17. PUBLIC = applies when compiling this lib AND propagates to
# anything that links it (so consumers also compile as >= C++17).
target_compile_features(my_custom_proj_name PUBLIC cxx_std_17)

# Declare the PUBLIC headers via a "file set" of type HEADERS. This single
# command does three jobs at once:
#   - marks these files as the public API,
#   - sets the include search path to BASE_DIRS while building (build tree),
#   - and, crucially, makes `install(... FILE_SET HEADERS)` below know what to
#     copy and what the installed include path should be.
# BASE_DIRS = the root the headers are relative to (becomes the -I dir).
# FILES     = the actual public header files.
# This replaces hand-writing $<BUILD_INTERFACE:...>/$<INSTALL_INTERFACE:...>.
target_sources(my_custom_proj_name PUBLIC
  FILE_SET HEADERS BASE_DIRS include
  FILES include/my_custom_proj_name/my_custom_proj_name.hpp)

# Install rule #1: copy the built library + its public headers into the install
# tree, and record this target in an export set named for the EXPORT keyword.
#   TARGETS    = which target(s) to install (the .a/.so).
#   EXPORT     = name of the export set; install(EXPORT ...) below writes it out.
#   FILE_SET HEADERS = also install the headers declared above (into <prefix>/include).
install(TARGETS my_custom_proj_name
  EXPORT my_custom_proj_nameTargets
  FILE_SET HEADERS)

# Install rule #2: serialize the export set to disk as a *Targets.cmake file.
# This is the on-disk record of the target's usage requirements (include dirs,
# C++17, link deps) — the thing that survives after your build/ folder is gone.
#   NAMESPACE   = prefix applied to exported target names => my_custom_proj_name::...
#   DESTINATION = where the file is installed; lib/cmake/<name> is the convention
#                 find_package() searches.
install(EXPORT my_custom_proj_nameTargets
  NAMESPACE my_custom_proj_name::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/my_custom_proj_name)

# Generate the package Config file from the .in template (see bottom). This is
# what find_package(my_custom_proj_name) actually loads first. The helper makes
# it RELOCATABLE (works no matter what --prefix the consumer installed under).
#   arg 1 = input template (.in)
#   arg 2 = generated output, placed in the build dir
#   INSTALL_DESTINATION = where it will ultimately be installed (used to compute
#                         relocatable relative paths inside the file).
configure_package_config_file(
  cmake/my_custom_proj_nameConfig.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/my_custom_proj_nameConfig.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/my_custom_proj_name)

# Generate the version file so `find_package(<name> 1.0)` can enforce a version.
#   arg 1 = output file (version is taken from project(... VERSION ...) above).
#   COMPATIBILITY SameMajorVersion = a request for 1.x is satisfied by any 1.y,
#                                    but NOT by 2.x (semantic-versioning style).
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/my_custom_proj_nameConfigVersion.cmake"
  COMPATIBILITY SameMajorVersion)

# Install rule #3: copy the two generated package files (Config + ConfigVersion)
# next to the Targets file, so find_package() finds the complete package.
#   FILES       = the specific files to copy.
#   DESTINATION = same lib/cmake/<name> dir as the Targets file.
install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/my_custom_proj_nameConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/my_custom_proj_nameConfigVersion.cmake"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/my_custom_proj_name)

# =============================================================================
# Supporting file — save as: cmake/my_custom_proj_nameConfig.cmake.in
# -----------------------------------------------------------------------------
#   @PACKAGE_INIT@ is expanded by configure_package_config_file into boilerplate
#   that sets up relocatable path helpers. Then we include the Targets file to
#   actually import the target. If this library had external dependencies, add
#   `include(CMakeFindDependencyMacro)` + `find_dependency(Foo)` lines ABOVE the
#   include, so consumers transitively get them too.
#
# @PACKAGE_INIT@
# include("${CMAKE_CURRENT_LIST_DIR}/my_custom_proj_nameTargets.cmake")
# =============================================================================]]
  ),
  simple(
    'cmake_including',
    [[
  # =============================================================================
  # REFERENCE: consuming an external library in CMake — the 5 methods
  # =============================================================================
  # DECISION TREE — pick a method:
  #
  #   Is the dep already INSTALLED as a CMake package (system / vcpkg / Conan)?
  #     └─ YES → #1 find_package(... CONFIG)        ← most common, preferred
  #   Is it an old lib with no Config, but CMake (or you) ships a FindXxx.cmake?
  #     └─ YES → #2 find_package(...)  [MODULE mode]
  #   Do you want to BUILD IT FROM SOURCE, pinned to a tag, no install step?
  #     └─ YES → #3 FetchContent                    ← great for CI / reproducible
  #   Is the dep's SOURCE vendored inside your repo (submodule / copied)?
  #     └─ YES → #4 add_subdirectory
  #   Is it non-CMake, or must be built in isolation (own toolchain/flags)?
  #     └─ YES → #5 ExternalProject_Add             ← heaviest, last resort
  #
  # All of #1–#4 converge on the SAME final line:
  #     target_link_libraries(app PRIVATE Foo::Foo)
  # =============================================================================


  # ── #1  find_package — CONFIG mode  (consume an installed CMake package) ─────
  # The dep shipped FooConfig.cmake (like your kash did). Point CMake at the
  # install prefix at configure time:
  #     cmake -S . -B build -DCMAKE_PREFIX_PATH=/path/to/install
  find_package(Foo 1.2 CONFIG REQUIRED)        # version is checked vs FooConfigVersion.cmake
  target_link_libraries(app PRIVATE Foo::Foo)  # include dirs + std + deps all propagate


  # ── #2  find_package — MODULE mode  (legacy / non-CMake libs) ────────────────
  # No Config file exists; a FindFoo.cmake module locates headers+libs by hand.
  # CMake bundles many: Threads, ZLIB, OpenSSL, Boost, CURL, Python...
  find_package(Threads REQUIRED)               # runs FindThreads.cmake
  target_link_libraries(app PRIVATE Threads::Threads)
  #   find_package(OpenSSL REQUIRED)  → OpenSSL::SSL  OpenSSL::Crypto
  #   find_package(ZLIB    REQUIRED)  → ZLIB::ZLIB
  # (CONFIG is tried first if present; otherwise CMake falls back to MODULE.)


  # ── #3  FetchContent  (download + build from source, at configure time) ──────
  include(FetchContent)
  FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG        10.2.1          # ALWAYS pin a tag/commit — never a branch — for reproducibility
    # URL https://.../fmt-10.2.1.tar.gz   # (alternative: a release tarball + URL_HASH)
  )
  FetchContent_MakeAvailable(fmt)            # clones + add_subdirectory's it into your build
  target_link_libraries(app PRIVATE fmt::fmt)
  # Newer CMake: FetchContent_Declare(... FIND_PACKAGE_ARGS) lets find_package()
  # use a system copy first and fall back to fetching — best of #1 and #3.


  # ── #4  add_subdirectory  (vendored source already in your tree) ─────────────
  # vendored/foo is a git submodule or copied-in source with its own CMakeLists.
  add_subdirectory(vendored/foo)             # FetchContent is basically this + auto-clone
  target_link_libraries(app PRIVATE foo::foo)
  #   EXCLUDE_FROM_ALL keeps its extra targets (tests/examples) out of your build:
  #   add_subdirectory(vendored/foo EXCLUDE_FROM_ALL)


  # ── #5  ExternalProject_Add  (build at BUILD time, fully isolated) ───────────
  include(ExternalProject)
  ExternalProject_Add(foo_ext
    GIT_REPOSITORY https://github.com/org/foo.git
    GIT_TAG        v1.0
    CMAKE_ARGS     -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>   # builds in its OWN configure/build/install
  )
  # CAVEAT: it builds during `cmake --build`, so there is NO imported target at
  # configure time. You must wire include/link dirs + add_dependencies() yourself.
  # Use only when #1–#4 can't (non-CMake build, conflicting toolchain, etc.).]]
  ),
  simple(
    'cmake_install_minimal_find_pkg',
    [[
cmake_minimum_required(VERSION 3.15...4.1)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
project(user_proj LANGUAGES CXX)

add_executable(app src/main.cpp)

find_package(kash 1.0 CONFIG REQUIRED)        # version is checked vs FooConfigVersion.cmake

target_link_libraries(app PRIVATE kash::kash)  # include dirs + std + deps all 
# propagate]]
  ),
  simple(
    'randomcpp',
    [[
  std::random_device rd;
  std::mt19937 gen(rd());                       // one engine, created once, passed by reference
  std::uniform_real_distribution<double> dist(lo, hi);
  double x = dist(gen);]]
  ),
  simple(
    'clang-format_benoits_style',
    [[
ColumnLimit: 100
---
Language: Cpp
BasedOnStyle: LLVM
IndentWidth: 2
TabWidth: 2
UseTab: Never
PointerAlignment: Left
ReferenceAlignment: Left
NamespaceIndentation: None
AccessModifierOffset: -2
BreakAfterReturnType: All
ReflowComments: false
SortIncludes: Never
SpaceBeforeParens: Never
SpacesInParens: Custom
SpacesInParensOptions:
  InEmptyParentheses: false
  Other: true
SpaceAfterTemplateKeyword: true
AllowShortFunctionsOnASingleLine: Inline
AllowShortIfStatementsOnASingleLine: AllIfsAndElse
BreakBeforeBraces: Custom
BraceWrapping:
  AfterFunction: true
  AfterClass: true
  AfterStruct: true
  AfterUnion: true
  AfterEnum: true
  AfterNamespace: true
  AfterControlStatement: Never
  BeforeElse: true
  BeforeCatch: true
  SplitEmptyFunction: false
  SplitEmptyRecord: false]]
  ),
  simple(
    'bitbucket_pipeline',
    [[
# Enforce formatting in CI. Checks ONLY the files changed in the PR (diff against the
# destination branch), so existing unformatted code needs no upfront reformat.
# clang-format comes from the pinned pre-commit hook, not the system.
image: python:3.12

pipelines:
  pull-requests:
    '**':
      - step:
          name: formatting (pre-commit, changed files)
          caches:
            - pip
          script:
            - pip install pre-commit
            - git fetch origin "$BITBUCKET_PR_DESTINATION_BRANCH"
            - pre-commit run --from-ref "origin/$BITBUCKET_PR_DESTINATION_BRANCH" --to-ref HEAD]]
  ),
  simple(
    'pyplot_import',
    [[
import matplotlib as plt
import numpy as np
import pandas as pd]]
  ),
}
