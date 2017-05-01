#include <iostream>
#include <stdio.h>     
#include <unistd.h>
#include <stdlib.h>  
#include <time.h> 
#include <queue>
#include <string>
#include <cstdlib>
#include <thread>
using namespace std;

//2D Store Layout
string StoreMatrix[10][4] = {
	{"0", "Aisle 0", "0", "Aisle 10"},
	{"0", "Aisle 1", "0", "Aisle 11"},
	{"0", "Aisle 2", "0", "Aisle 12"},
	{"0", "Aisle 3", "0", "Aisle 13"},
	{"0", "Aisle 4", "0", "Aisle 14"},
	{"0", "Aisle 5", "0", "Aisle 15"},
	{"0", "Aisle 6", "0", "Aisle 16"},
	{"0", "Aisle 7", "0", "Aisle 17"},
	{"0", "Aisle 8", "0", "Aisle 18"},
	{"0", "Aisle 9", "0", "Aisle 19"}
};

//Automation Bots
class Bot{
	private:
		string name;
		int x, y;
		int current_order;
		bool is_on;
		static int bots_in_use;

	public:
		Bot();
		Bot(string name, int x, int y,int current_order, bool is_on);
		void up();
		void down();
		void setPower(bool is_on);
		bool getPower();
		int setOrder(int a);
		string getName();
		int getX();
		static int setTotalBots(int bots_in_use);	 		
		void print();
};

int Bot::bots_in_use = 0;

Bot::Bot(string name, int x, int y, int current_order, bool is_on){
	this->name = name;
	this->x = x;
	this->y = y;
	this->current_order = current_order;
	this->is_on = is_on;
};

void Bot::up(){
	if(0 <= x && x <= 9 && y == 0){
		sleep(1);
		StoreMatrix[x][y] = "0";
		x--;
		StoreMatrix[x][y]= "R1";
	}

	if(0 <= x && x <= 9 && y == 2){
		sleep(1);
		StoreMatrix[x][y] = "0";
		x--;
		StoreMatrix[x][y]="R2";
	}
}

void Bot::down(){
	if(0 <= x && x <= 9 && y == 0){
		sleep(1);
		StoreMatrix[x][y] = "0";
		x++;
		StoreMatrix[x][y] = "R1";

	}

	if(0 <= x && x <= 9 && y == 2){
		sleep(1);
		StoreMatrix[x][y] = "0";
		x++;
		StoreMatrix[x][y] = "R2";
	}

}

void Bot::setPower(bool a){
	is_on = a;
	if(is_on == true){
		cout << "\n" << name << " IS ON!!!\n\n";
		bots_in_use++;
	}

	else{
		bots_in_use--;
	}

	if(y == 0){
		StoreMatrix[0][0] ="R1";
	}

	if(y == 2){
		StoreMatrix[0][2] ="R2";
	}
}
int Bot::setOrder(int a){
	current_order=a;
}

bool Bot::getPower(){
	return is_on;
}

int Bot::getX(){
	return x;
}

string Bot::getName(){
	return name;
}

void Bot::print(){
	cout << "Name: " << this->name << endl;
	cout << "Current Location: " << this-> x << ", " << this->y << endl;
	cout << "Current Order: " << this->current_order << endl;
	cout << "Power: " << this->is_on << endl;
	cout << "Total Bots: " << this->bots_in_use << endl;
	cout << endl;
}

void printStore(string a[10][4]){
	cout << "Store Layout" << endl;
	for(int i=0; i<10; i++){
		for(int j=0; j<4; j++){
			cout << a[i][j] << " ";
		};
		cout << endl;
	};

	cout << endl;

}

int main(){

	queue <int> order;
	Bot bot1("R1", 0, 0, 0, false);
	Bot bot2("R2", 0, 2, 0, false);

	cout << "Robotic Warehouse\n\n";

	printStore(StoreMatrix);
	sleep(2);
	bot1.setPower(true);
	sleep(2);
	bot2.setPower(true);
	sleep(2);

	while(true){
		int aisle, aisle2;
		srand(time(NULL));

		aisle = rand() % 10;
		order.push(aisle);
		bot1.setOrder(aisle);

		aisle2 = rand() % 10 + 10;
		order.push(aisle2);
		bot2.setOrder(aisle2);

		cout << "ORDER ON AISLE: " << aisle << endl << endl;
		cout << "ORDER ON AISLE: " << aisle2 << endl << endl;
		sleep(2);

		printStore(StoreMatrix);
		bot1.print();
		bot2.print();
		sleep(1);

		while(aisle!= bot1.getX() || aisle2!= (bot2.getX()+10)){
		if(aisle != bot1.getX()){
			//bot1.down();
			thread t1(&Bot::down, &bot1);
			t1.join();
			printStore(StoreMatrix);
			bot1.print();

		}
		if(aisle2 != (bot2.getX()+10)){
			//bot2.down();
			thread t2(&Bot::down, &bot2);
			t2.join();
			printStore(StoreMatrix);
			bot2.print();
		}
		}
		if(aisle == bot1.getX()){
			cout<< "ORDER ON AISLE " << aisle << " RETRIEVED BY ROBOT " << bot1.getName() << "!!!\n\n";
		}
		if(aisle2==bot2.getX()+10){
			cout<< "ORDER ON AISLE " << aisle2 << " RETRIEVED BY ROBOT " << bot2.getName() << "!!!\n\n";
		}
		sleep(2);

		while(bot1.getX()!=0 ||bot2.getX()!=0){
		if(bot1.getX() != 0){
			//bot1.up();
			thread t3(&Bot::up, &bot1);
			t3.join();			
			printStore(StoreMatrix);
			bot1.print();
		}

		if(bot2.getX() != 0){
			//bot2.up();
			thread t4(&Bot::up, &bot2);		
			t4.join();	
			printStore(StoreMatrix);
			bot2.print();
		}
		}
		
		cout << "ORDER " << aisle<< " SENT TO CUSTOMER!!!\n\n";
		cout << "ORDER " << aisle2<< " SENT TO CUSTOMER!!!\n\n";
		sleep(2);
	}

	return 0;
}
