#include <stdio.h>      // For printf
#include <stdint.h>     // For  (uint32_t, etc.)

int main(void)
{
    // This is the Base address of the memory-mapped registers for the Add/Sub hardware block
    uint32_t *regmap = (uint32_t *)0x70000000;

    // This variable to hold result read back from hardware
    size_t S;



    //  Random Testing

    // Random-like addition #1
    regmap[0] = 111111111;
    regmap[1] = 222222222;
    regmap[2] = 0;
    S = regmap[0];
    printf("%2zu + %2zu = %3zu (%s)\n",
           (size_t)111111111, (size_t)222222222, S,
           (S == (uint32_t)(111111111ULL + 222222222ULL)) ? "COR" : "ERR");

    // Random-like subtraction
    regmap[0] = 2500000000U;
    regmap[1] = 987654321U;
    regmap[2] = 1;
    S = regmap[0];
    printf("%2zu - %2zu = %3zu (%s)\n",
           (size_t)2500000000U, (size_t)987654321U, S,
           (S == (uint32_t)(2500000000ULL - 987654321ULL)) ? "COR" : "ERR");

    // Random-like addition #2
    regmap[0] = 135791357;
    regmap[1] = 246802468;
    regmap[2] = 0;
    S = regmap[0];
    printf("%2zu + %2zu = %3zu (%s)\n",
           (size_t)135791357, (size_t)246802468, S,
           (S == (uint32_t)(135791357ULL + 246802468ULL)) ? "COR" : "ERR");

    //Corner Cases

       // 1. Subtraction: positive result
           regmap[0] = 500;
           regmap[1] = 123;
           regmap[2] = 1;
           S = regmap[0];
           printf("%2zu - %2zu = %3zu (%s)\n",
                  (size_t)500, (size_t)123, S,
                  (S == (size_t)(500 - 123)) ? "COR" : "ERR");

       // 2. Addition with overflow: result > 2^32 - 1 (carry out expected)
       regmap[0] = 3800000000U;
       regmap[1] = 900000000U;
       regmap[2] = 0;
       S = regmap[0];
       printf("%2zu + %2zu = %3zu (%s)\n",
              (size_t)3800000000U, (size_t)900000000U, S,
              (S == (uint32_t)(3800000000ULL + 900000000ULL)) ? "COR" : "ERR");



           // 3. Subtraction: negative result (wraps around)
             regmap[0] = 75;
             regmap[1] = 200;
             regmap[2] = 1;
             S = regmap[0];
             printf("%2zu - %2zu = %3zu (%s)\n",
                    (size_t)75, (size_t)200, S,
                    (S == (uint32_t)(75 - (int64_t)200)) ? "COR" : "ERR");
       // 4. Subtraction: result = 0
       regmap[0] = 88888;
       regmap[1] = 88888;
       regmap[2] = 1;
       S = regmap[0];
       printf("%2zu - %2zu = %3zu (%s)\n",
              (size_t)88888, (size_t)88888, S,
              (S == 0) ? "COR" : "ERR");

       // 5. Simple addition: A + B fits in 32 bits (no carry out)
              regmap[0] = 750000000;
              regmap[1] = 125000000;
              regmap[2] = 0;
              S = regmap[0];
              printf("%2zu + %2zu = %3zu (%s)\n",
                     (size_t)750000000, (size_t)125000000, S,
                     (S == (size_t)750000000 + 125000000) ? "COR" : "ERR");



    // 6. Addition with zero
    regmap[0] = 123456789;
    regmap[1] = 0;
    regmap[2] = 0;
    S = regmap[0];
    printf("%2zu + %2zu = %3zu (%s)\n",
           (size_t)123456789, (size_t)0, S,
           (S == 123456789) ? "COR" : "ERR");

    // 7. Subtraction with zero
    regmap[0] = 987654321;
    regmap[1] = 0;
    regmap[2] = 1;
    S = regmap[0];
    printf("%2zu - %2zu = %3zu (%s)\n",
           (size_t)987654321, (size_t)0, S,
           (S == 987654321) ? "COR" : "ERR");

    // 8. Large equal subtraction
    regmap[0] = 3000000000U;
    regmap[1] = 3000000000U;
    regmap[2] = 1;
    S = regmap[0];
    printf("%2zu - %2zu = %3zu (%s)\n",
           (size_t)3000000000U, (size_t)3000000000U, S,
           (S == 0) ? "COR" : "ERR");

    // 9. Edge case: Max unsigned minus 1
    regmap[0] = 0xFFFFFFFFU; // max 32-bit unsigned
    regmap[1] = 1U;
    regmap[2] = 1;
    S = regmap[0];
    printf("%#x - %#x = %#x (%s)\n",
           0xFFFFFFFFU, 1U, (unsigned)S,
           (S == 0xFFFFFFFEU) ? "COR" : "ERR");

    return 0;  // End of program
}

