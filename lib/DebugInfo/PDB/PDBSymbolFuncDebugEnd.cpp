//===- PDBSymbolFuncDebugEnd.cpp - ------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DebugInfo/PDB/PDBSymbolFuncDebugEnd.h"

#include "llvm/DebugInfo/PDB/PDBSymbol.h"

#include <utility>

using namespace llvm;

PDBSymbolFuncDebugEnd::PDBSymbolFuncDebugEnd(
    const IPDBSession &PDBSession, std::unique_ptr<IPDBRawSymbol> Symbol)
    : PDBSymbol(PDBSession, std::move(Symbol)) {}

void PDBSymbolFuncDebugEnd::dump(raw_ostream &OS, int Indent,
                                 PDB_DumpLevel Level, PDB_DumpFlags Flags) const {}
