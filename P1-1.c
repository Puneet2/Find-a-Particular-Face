//=================================================================
// Copyright 2022 Georgia Tech.  All rights reserved.
// The materials provided by the instructor in this course are for
// the use of the students currently enrolled in the course.
// Copyrighted course materials may not be further disseminated.
// This file must not be made publicly available anywhere.
//=================================================================

/*    
Please fill in the following
 Student Name: Puneet Bansal
 Date: 2/14/22

ECE 2035 Project 1-1

This is the only file that should be modified for the C implementation
of Project 1.

Do not include any additional libraries.
------------------------------------------

This program finds an exact match of George's face which may be rotated
in a crowd of tumbling (rotated) faces. It reports the location of his
hat and shirt as pixel positions.  The pixels are specified as linear
offsets from the crowd image base.*/

#include <stdio.h>
#include <stdlib.h>

#define DEBUG 1 // RESET THIS TO 0 BEFORE SUBMITTING YOUR CODE

int main(int argc, char *argv[]) {
   int	             CrowdInts[1024];
   // This allows you to access the pixels (individual bytes)
   // as byte array accesses (e.g., Crowd[25] gives pixel 25):
   char *Crowd = (char *)CrowdInts;
   int	             NumInts, HatLoc=0, ShirtLoc=0;
   int               Load_Mem(char *, int *);

   if (argc != 2) {
     printf("usage: ./P1-1 testcase_file\n");
     exit(1);
   }
   NumInts = Load_Mem(argv[1], CrowdInts);
   if (NumInts != 1024) {
      printf("valuefiles must contain 1024 entries\n");
      exit(1);
   }
   if (DEBUG){
     printf("Crowd[0] is Pixel 0: 0x%02x\n", Crowd[0]);
     printf("Crowd[107] is Pixel 107: 0x%02x\n", Crowd[107]);
   }
   int George[12] = {1,2,1,2,5,5,5,8,5,5,5,3}; // array of color to check if image is George
   int i; // counter
   int found = 0; // if face found
   for(i = 0; i<4096; i++){ // to go through every pixel
      if(Crowd[i] == 7){ // if there is a green pixel
         if(i+4<4096 && Crowd[i+4] == 7){ // face is oriented at 0 or 180 deg    
            if(i-64 >= 0 && Crowd[i-64]==2){ // face is 0 deg
               int k = 0; // counter to loop 12 times
               int j = i-255; // counter to go through pixels
               int complete = 1; //if the pattern is equal to the george array
               for(k = 0; k<12; k++){ // for loop to check the pixels
                  if(Crowd[j]!=George[k]){ //if the pattern is not equal to the george array
                     complete = 0; // set complete to false
                     break; 
                  }
                  j += 64; // increment the j counter 
               }
               if(complete){ // checks to see if the for loop completed
                  HatLoc = i - 254; // set hat position
                  ShirtLoc = i + 450; // set shirt location
                  found = 1; // sets the boolean found to true
               }

            }
            else if(i+64 < 4096 && Crowd[i+64]==2){// face is 180 deg   
               int k = 0;  // counter to loop 12 times
               int j = i+257; // counter to go through pixels
               int complete = 1; //if the pattern is equal to the george array
               for(k = 0; k<12; k++){ // for loop to check the pixels
                  if(Crowd[j]!=George[k]){ //if the pattern is not equal to the george array
                     complete = 0;  // set complete to false
                     break;
                  }
                  j -= 64;// increment the j counter 
               }
               if(complete){ // checks to see if the for loop completed
                  HatLoc = i + 258; // set hat position
                  ShirtLoc = i - 446; // set shirt location
                  found = 1; // sets the boolean found to true
               }
            }
         }
         else if(i+256<4096 && Crowd[i+256] == 7){ // face is oriented by 90 or 270 deg    
            if(i+1<4096  && Crowd[i+1]==2){ // face is 270 deg         
               int k = 0; // counter to loop 12 times
               int j = i+68; // counter to go through pixels
               int complete = 1; //if the pattern is equal to the george array
               for(k = 0; k<12; k++){ // for loop to check the pixels
                  if(Crowd[j]!=George[k]){ //if the pattern is not equal to the george array
                     complete = 0; // set complete to false
                     break;
                  }
                  j -= 1; // increment the j counter 
               }
               if(complete){ // checks to see if the for loop completed
                  HatLoc = i + 132; // set hat position
                  ShirtLoc = i + 121; // set shirt location
                  found = 1; // sets the boolean found to true
               }
            }
            else if(i-1 >= 0 && Crowd[i-1]==2){// face is 90 deg      
               int k = 0; // counter to loop 12 times
               int j = i+60; // counter to go through pixels
               int complete = 1; //if the pattern is equal to the george array
               for(k = 0; k<12; k++){ // for loop to check the pixels
                  if(Crowd[j]!=George[k]){ //if the pattern is not equal to the george array
                     complete = 0; // set complete to false
                     break;
                  }
                  j += 1; // increment the j counter 
               }
               if(complete){ // checks to see if the for loop completed
                  HatLoc = i + 124; // set hat position
                  ShirtLoc = i + 135; // set shirt location
                 found = 1; // sets the boolean found to true
               }
            }
         }
      }
      if(found){ // checks if george was found
         break; // if he is found stop searching
      }
   }
   printf("George is located at: hat pixel %d, shirt pixel %d.\n", HatLoc, ShirtLoc);
   exit(0);
}

/* This routine loads in up to 1024 newline delimited integers from
a named file in the local directory. The values are placed in the
passed integer array. The number of input integers is returned. */

int Load_Mem(char *InputFileName, int IntArray[]) {
   int	N, Addr, Value, NumVals;
   FILE	*FP;

   FP = fopen(InputFileName, "r");
   if (FP == NULL) {
      printf("%s could not be opened; check the filename\n", InputFileName);
      return 0;
   } else {
      for (N=0; N < 1024; N++) {
         NumVals = fscanf(FP, "%d: %d", &Addr, &Value);
         if (NumVals == 2)
            IntArray[N] = Value;
         else
            break;
      }
      fclose(FP);
      return N;
   }
}
