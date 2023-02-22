#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "parser.h"
#include "parser.c"
#include <iostream>
#include <vector>
#include <fcntl.h>

using namespace std;

struct b_commands       //List to store bundle commands
{
    vector <vector<char *>> command_lst ;  //commands in a bundle 
    string bundle_name;                   //bundle's name
    int bundle_id;                        //bundle's id
};


int max_process_num(vector<b_commands>& all_bundles){

   int maxres = 0;
   for(int i=0; i < all_bundles.size(); i++){
        if (all_bundles[i].command_lst.size() > maxres){
            maxres = all_bundles[i].command_lst.size();
        }
   }
   return maxres;
}


int execute_bundles(vector<b_commands> all_bundles, parsed_input * parsing, int ind){


    //cout << "EXE BUNDLES" << endl;
    int bundle_count = parsing->command.bundle_count;
    int pids[bundle_count];
    string bundleName;
    int i, index, next_index, file, child_file;;
    int b_PROCESS_NUM, nextb_PROCESS_NUM, MAX_PROCESS_NUM;

    MAX_PROCESS_NUM = max_process_num(all_bundles);

    int pipes[bundle_count+1][2];
    char* text;
    int repeater;

    for (int z = 1; z < bundle_count+1; z++) {            //Create Pipes
        if (pipe(pipes[z]) == -1) {
                printf("Error with creating pipe\n");
                return 1;
        }
    }


    for (i = 0; i < bundle_count; i++) {                    //go over all exec bundles
 
        //cout << " I == " << i << endl;
        bundleName = parsing->command.bundles[i].name;
        for (int y = 0; y < all_bundles.size(); y++) {   
            if ( bundleName == all_bundles[y].bundle_name){  //find index of bundle in vector
                    index = y;
            }
        }

        //cout << bundleName << " I == " << i  << " index-" << index << endl;

        char * INPUT = parsing->command.bundles[i].input;    
        char * OUTPUT = parsing->command.bundles[i].output;

        pids[i] = fork();

        if (pids[i]==0){            //child process to run bundle


            for (int y = 1; y < bundle_count+1; y++) {
                if (y != i && y != i+1) {
                    close(pipes[y][0]);
                    close(pipes[y][1]);
                }
            }

            if ( i == 0 ){                 //first bundle

                if (INPUT){                //Add input redirection
                file = open(INPUT, O_RDONLY, 0777);
                dup2(file,STDIN_FILENO);
                close(file);
                }
                //cout <<  "Comes 87 " << i << endl;
                close(pipes[i][0]);
                close(pipes[i][1]); 
                close(pipes[i+1][0]);
                dup2(pipes[i+1][1],STDOUT_FILENO);
                close(pipes[i+1][1]);

            }
            else if (i == bundle_count-1){      //last bundle
                if (OUTPUT){                    //Output redirection block
                file = open(OUTPUT, O_CREAT | O_APPEND  | O_WRONLY, 0777);
                dup2(file,STDOUT_FILENO);
                close(file);
                }
                //cout <<  "Comes 104 " << i << endl;
                close(pipes[i+1][0]);
                close(pipes[i+1][1]);
                close(pipes[i][1]); 
                dup2(pipes[i][0],STDIN_FILENO);
                close(pipes[i][0]);
            }
            else{
                close(pipes[i][1]);
                dup2(pipes[i][0],STDIN_FILENO);
                close(pipes[i][0]); 
                close(pipes[i+1][0]);
                dup2(pipes[i+1][1],STDOUT_FILENO);
                close(pipes[i+1][1]);              
            }
            //cout <<  "Comes 120  " << i << endl;
            int arr_size = all_bundles[index].command_lst[0].size()+1;
            char* arr[arr_size];
            int x=0;
            for ( ; x < arr_size-1 ; x++){
                arr[x] = all_bundles[index].command_lst[0][x]; //fill up array with arguments
            }
            arr[x] = NULL;
            //cout << arr[0] << "--" << i << endl;
            execvp(arr[0],  arr);       //execute the process
            return 0;                   //if process fails end it
        }


    }

    //cout << "EXIT LOOP" << endl;
    for (int z = 1; z < bundle_count+1; z++) {            //close parent pipes
        close(pipes[z][0]);
        close(pipes[z][1]);
    }
    for (int z = 0; z < bundle_count; z++) {            //close parent pipes
        wait(NULL);
        //cout << "Waited for a child" << endl;
    }

    return 0;
}


int execute_bundle_only_one(vector<b_commands> all_bundles, parsed_input * parsing, int ind){

    int PROCESS_NUM;
    int file,file2;
    if (parsing->command.bundle_count == 1){      //make sure called for 1 bundle

        int pid;
        PROCESS_NUM = all_bundles[ind].command_lst.size(); //Number of processes in a bundle

        char * INPUT = parsing->command.bundles->input;    
        char * OUTPUT = parsing->command.bundles->output;


        int pids[PROCESS_NUM];
        for (int j = 0; j < PROCESS_NUM; j++) { //Each loop creates 1 child which runs 1 process.
            pids[j] = fork();                   //Create Child
            if (pids[j] == 0) {
                //Child Process

                if (INPUT){     //Add input to all the processes
                    file = open(INPUT, O_RDONLY, 0777);
                    dup2(file,STDIN_FILENO);
                    close(file);
                }
                if (OUTPUT){               //Output redirection block
                    file = open(OUTPUT, O_CREAT | O_APPEND  | O_WRONLY, 0777);
                    dup2(file,STDOUT_FILENO);
                    close(file);
                }

                int arr_size = all_bundles[ind].command_lst[j].size()+1;
                char* arr[arr_size];
                int i=0;
                for ( ; i < arr_size-1 ; i++){
                    arr[i] = all_bundles[ind].command_lst[j][i]; //fill up array with arguments
                }
                arr[i] = NULL;
                execvp(arr[0],  arr);       //execute the process
                return 0;                   //if process fails kill the child
            }
        }
        //Wait for all children to die
        for (int i = 0; i < PROCESS_NUM; i++) {
            wait(NULL);
        }

    }
    return 0;
}

int main (int argc, char** argv){
    char line[256];
    parsed_input parsing[256];
    int is_bundle=0;
    char* for_argv [20];

    int x = 0,i,j,k,y;
    int execute_flag = 0;
    int first_bundle_index;

    struct parsed_command *pc = new parsed_command; 
    parsing->command = *pc;
    parsing->argv = for_argv;

    vector<b_commands> all_bundles;
    b_commands temp_b_comm;
    int busy_in_creation=0;

    while (1){


        fgets(line, 256, stdin);
        char bundle_name[20];

        char delimiter[] = " ";
        string firstWord;
        char *secondWord, *remainder, *context;
        int inputLength = strlen(line);
        char *inputCopy = (char*) calloc(inputLength + 1, sizeof(char));
        strncpy(inputCopy, line, inputLength);

        firstWord = strtok_r (inputCopy, delimiter, &context);
        secondWord = strtok_r (NULL, delimiter, &context);
        remainder = context;

        for(int i=0; i < all_bundles.size(); i++){
            if (  firstWord == all_bundles[i].bundle_name || firstWord == all_bundles[i].bundle_name + "\n" ){
                execute_flag = 1;
                first_bundle_index = i;
            }
        }

        if (execute_flag){
            parse(line, 0, parsing);
            if (parsing->command.bundle_count == 1){ 
                int p = execute_bundle_only_one(all_bundles,parsing,first_bundle_index);
            }
            else{
                int p = execute_bundles(all_bundles,parsing,first_bundle_index);
            }
            execute_flag = 0;
        }

        else if (firstWord == "quit\n" && busy_in_creation == 0 ){
            break;                      
        }
        else if (firstWord == "pbc" && busy_in_creation == 0){
            parse(line, 0, parsing);                      //start bundle processing
            busy_in_creation = 1;
        }
        else if (firstWord == "pbs\n" && busy_in_creation == 1){
            busy_in_creation = 0;
            parse(line, 0, parsing);                      //finish bundle processing
            all_bundles.push_back(temp_b_comm);
            temp_b_comm.command_lst.clear();
            temp_b_comm.bundle_name = "";
            temp_b_comm.bundle_id = -1;
            x = 0;
        }
        else{
            vector<char *> line_comm;

            parse(line, 1, parsing);

            if (x == 0){
                temp_b_comm.bundle_name = parsing->command.bundle_name;
                temp_b_comm.bundle_id = parsing->command.bundle_count;
            }


            y = 0;                          //y is for argument check
            while (parsing->argv[y] != NULL){
                line_comm.push_back(parsing->argv[y]);
                y++;
            }

            temp_b_comm.command_lst.push_back(line_comm);
            //print2(temp_b_comm.command_lst);

            x++;

        }
    }
    return 0;
}