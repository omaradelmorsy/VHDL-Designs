#include <stdio.h>
#include <stdint.h>

int main(void)
{
    uint32_t *regmap = (uint32_t *)0x70000000;
    size_t R, Zero, Overflow;

    printf("=== Comprehensive ALU Testbench ===\n\n");

    // Test Case 1: Logic AND Operation
    regmap[0] = 0xAAAAAAAA;     // A input -> REG0_OUT
    regmap[1] = 0xCCCCCCCC;     // B input -> REG1_OUT
    regmap[5] = 0x0000;         // ALUOp -> REG5_OUT (AND)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X AND 0x%08X = 0x%08zX (Expected: 0x88888888) %s\n",
           0xAAAAAAAA, 0xCCCCCCCC, R, (R == (size_t)0x88888888) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 2: Logic OR Operation
    regmap[0] = 0xAAAAAAAA;     // A input -> REG0_OUT
    regmap[1] = 0xCCCCCCCC;     // B input -> REG1_OUT
    regmap[5] = 0x0001;         // ALUOp -> REG5_OUT (OR)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X OR  0x%08X = 0x%08zX (Expected: 0xEEEEEEEE) %s\n",
           0xAAAAAAAA, 0xCCCCCCCC, R, (R == (size_t)0xEEEEEEEE) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 3: Logic XOR Operation
    regmap[0] = 0xAAAAAAAA;     // A input -> REG0_OUT
    regmap[1] = 0xCCCCCCCC;     // B input -> REG1_OUT
    regmap[5] = 0x0002;         // ALUOp -> REG5_OUT (XOR)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X XOR 0x%08X = 0x%08zX (Expected: 0x66666666) %s\n",
           0xAAAAAAAA, 0xCCCCCCCC, R, (R == (size_t)0x66666666) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 4: Logic NOR Operation
    regmap[0] = 0xAAAAAAAA;     // A input -> REG0_OUT
    regmap[1] = 0xCCCCCCCC;     // B input -> REG1_OUT
    regmap[5] = 0x0003;         // ALUOp -> REG5_OUT (NOR)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X NOR 0x%08X = 0x%08zX (Expected: 0x11111111) %s\n",
           0xAAAAAAAA, 0xCCCCCCCC, R, (R == (size_t)0x11111111) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 5: Arithmetic ADD Operation
    regmap[0] = 5;              // A input -> REG0_OUT
    regmap[1] = 3;              // B input -> REG1_OUT
    regmap[5] = 0x0004;         // ALUOp -> REG5_OUT (ADD)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("%2zu + %2zu = %3zu (Expected: 8) %s\n",
           (size_t)5, (size_t)3, R, (R == (size_t)8) ? "COR" : "ERR");
    printf("Zero=%zu (Expected: 0), Overflow=%zu (Expected: 0)\n\n", Zero, Overflow);

    // Test Case 6: ADD with Large Numbers (Test Carry)
    regmap[0] = 4000000000U;    // A input -> REG0_OUT
    regmap[1] = 500000000U;     // B input -> REG1_OUT
    regmap[5] = 0x0005;         // ALUOp -> REG5_OUT (ADDU)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("%2zu + %2zu = %3zu (Unsigned add with carry) %s\n",
           (size_t)4000000000U, (size_t)500000000U, R,
           (R == (uint32_t)(4000000000ULL + 500000000ULL)) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 7: Overflow Test (Max positive + 1)
    regmap[0] = 0x7FFFFFFF;     // A input -> REG0_OUT (max positive 32-bit)
    regmap[1] = 0x00000001;     // B input -> REG1_OUT
    regmap[5] = 0x0004;         // ALUOp -> REG5_OUT (ADD signed)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X + 0x%08X = 0x%08zX (Overflow test) %s\n",
           0x7FFFFFFF, 0x00000001, R, (R == (size_t)0x80000000) ? "COR" : "ERR");
    printf("Zero=%zu (Expected: 0), Overflow=%zu (Expected: 1) %s\n\n",
           Zero, Overflow, (Overflow == 1) ? "COR" : "ERR");

    // Test Case 8: Arithmetic SUB Operation
    regmap[0] = 8;              // A input -> REG0_OUT
    regmap[1] = 3;              // B input -> REG1_OUT
    regmap[5] = 0x0006;         // ALUOp -> REG5_OUT (SUB)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("%2zu - %2zu = %3zu (Expected: 5) %s\n",
           (size_t)8, (size_t)3, R, (R == (size_t)5) ? "COR" : "ERR");
    printf("Zero=%zu (Expected: 0), Overflow=%zu (Expected: 0)\n\n", Zero, Overflow);

    // Test Case 9: SUB with Zero Result (Test Zero Flag)
    regmap[0] = 55555;          // A input -> REG0_OUT
    regmap[1] = 55555;          // B input -> REG1_OUT
    regmap[5] = 0x0006;         // ALUOp -> REG5_OUT (SUB)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("%2zu - %2zu = %3zu (Expected: 0) %s\n",
           (size_t)55555, (size_t)55555, R, (R == 0) ? "COR" : "ERR");
    printf("Zero=%zu (Expected: 1), Overflow=%zu (Expected: 0) %s\n\n",
           Zero, Overflow, (Zero == 1) ? "COR" : "ERR");

    // Test Case 10: SUB Negative Result (Underflow)
    regmap[0] = 42;             // A input -> REG0_OUT
    regmap[1] = 100;            // B input -> REG1_OUT
    regmap[5] = 0x0007;         // ALUOp -> REG5_OUT (SUBU)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("%2zu - %2zu = %3zu (Unsigned underflow) %s\n",
           (size_t)42, (size_t)100, R,
           (R == (uint32_t)(42 - (int64_t)100)) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 11: Comparison SLT Operation (A < B)
    regmap[0] = 3;              // A input -> REG0_OUT
    regmap[1] = 5;              // B input -> REG1_OUT
    regmap[5] = 0x000A;         // ALUOp -> REG5_OUT (SLT)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("%2zu < %2zu = %3zu (Expected: 1) %s\n",
           (size_t)3, (size_t)5, R, (R == (size_t)1) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 12: Comparison SLT Operation (A >= B)
    regmap[0] = 7;              // A input -> REG0_OUT
    regmap[1] = 3;              // B input -> REG1_OUT
    regmap[5] = 0x000A;         // ALUOp -> REG5_OUT (SLT)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("%2zu < %2zu = %3zu (Expected: 0) %s\n",
           (size_t)7, (size_t)3, R, (R == (size_t)0) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 13: Comparison SLTU Operation
    regmap[0] = 0xFFFFFFFE;     // A input -> REG0_OUT (large unsigned)
    regmap[1] = 0xFFFFFFFF;     // B input -> REG1_OUT (larger unsigned)
    regmap[5] = 0x000B;         // ALUOp -> REG5_OUT (SLTU)
    regmap[6] = 0x00;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X < 0x%08X = %zu (Unsigned, Expected: 1) %s\n",
           0xFFFFFFFE, 0xFFFFFFFF, R, (R == (size_t)1) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 14: Shift Left Logical
    regmap[0] = 0xFEDCBA98;     // A input -> REG0_OUT
    regmap[1] = 0x00000000;     // B input -> REG1_OUT
    regmap[5] = 0x000C;         // ALUOp -> REG5_OUT (SLL)
    regmap[6] = 0x01;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X << 1 = 0x%08zX (Expected: 0xFDB97530) %s\n",
           0xFEDCBA98, R, (R == (size_t)0xFDB97530) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 15: Shift Left by 4
    regmap[0] = 0xFEDCBA98;     // A input -> REG0_OUT
    regmap[1] = 0x00000000;     // B input -> REG1_OUT
    regmap[5] = 0x000C;         // ALUOp -> REG5_OUT (SLL)
    regmap[6] = 0x04;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X << 4 = 0x%08zX (Expected: 0xEDCBA980) %s\n",
           0xFEDCBA98, R, (R == (size_t)0xEDCBA980) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 16: Shift Right Logical
    regmap[0] = 0xFEDCBA98;     // A input -> REG0_OUT
    regmap[1] = 0x00000000;     // B input -> REG1_OUT
    regmap[5] = 0x000E;         // ALUOp -> REG5_OUT (SRL)
    regmap[6] = 0x01;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X >> 1 = 0x%08zX (Expected: 0x7F6E5D4C) %s\n",
           0xFEDCBA98, R, (R == (size_t)0x7F6E5D4C) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 17: Shift Right Arithmetic
    regmap[0] = 0xFEDCBA98;     // A input -> REG0_OUT
    regmap[1] = 0x00000000;     // B input -> REG1_OUT
    regmap[5] = 0x000F;         // ALUOp -> REG5_OUT (SRA)
    regmap[6] = 0x01;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X >>> 1 = 0x%08zX (Expected: 0xFF6E5D4C) %s\n",
           0xFEDCBA98, R, (R == (size_t)0xFF6E5D4C) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    // Test Case 18: Shift Right Arithmetic (Positive Number)
    regmap[0] = 0x7EDCBA98;     // A input -> REG0_OUT (positive)
    regmap[1] = 0x00000000;     // B input -> REG1_OUT
    regmap[5] = 0x000F;         // ALUOp -> REG5_OUT (SRA)
    regmap[6] = 0x01;           // SHAMT -> REG6_OUT
    R = regmap[0];              // R output <- REG0_IN
    Zero = regmap[3];           // Zero flag <- REG3_IN
    Overflow = regmap[4];       // Overflow flag <- REG4_IN
    printf("0x%08X >>> 1 = 0x%08zX (Positive SRA, Expected: 0x3F6E5D4C) %s\n",
           0x7EDCBA98, R, (R == (size_t)0x3F6E5D4C) ? "COR" : "ERR");
    printf("Zero=%zu, Overflow=%zu\n\n", Zero, Overflow);

    printf("=== ALU Testbench Complete ===\n");

    return 0;
}
