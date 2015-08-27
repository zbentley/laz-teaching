struct mystruct {
	int v;
};

void new(int initial_v) {
	mystruct inst = malloc(sizeof(mystruct));
	inst->v = initial_v;
	return inst;
}

int get_v(mystruct instance) {
	return instance->v;
}

void set_v(mystruct instance, int new_v) {
	instance->v = new_v;
	return;
}