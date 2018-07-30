float4 LJ_Force_hdl(float4 ref, float4 neighbor)
{
	
//	printf("Disclaimer: This emulation model just serve as a place holder provided by Chen Yang, the results may not 100% reflects the on board running result!\n");
	// the logic here is not what the custom func is doing, don't use this result for verification
	float dx = ref[0] - neighbor[0];
	float dy = ref[1] - neighbor[1];
	float dz = ref[2] - neighbor[2];
	float r2 = dx*dx + dy*dy + dz*dz;
	
	float inv_r2 = 1 / r2;
	float inv_r4 = inv_r2 * inv_r2;
	float inv_r8 = inv_r4 * inv_r4;
	float inv_r14 = inv_r8 * inv_r4 * inv_r2;
	
	float LJ_Force = 48*inv_r14 - 24*inv_r8;
	
	float LJ_Force_x = LJ_Force * dx;
	float LJ_Force_y = LJ_Force * dy;
	float LJ_Force_z = LJ_Force * dz;
	
	float4 LJ_Force_Components = (float4){0.0f, LJ_Force_z, LJ_Force_y, LJ_Force_x};
	return LJ_Force_Components;
}
