
user/_attacktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
char output[64];

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
   8:	611c                	ld	a5,0(a0)
   a:	0017d693          	srli	a3,a5,0x1
   e:	c0000737          	lui	a4,0xc0000
  12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdfa1>
  14:	1706                	slli	a4,a4,0x21
  16:	0725                	addi	a4,a4,9
  18:	02e6b733          	mulhu	a4,a3,a4
  1c:	8375                	srli	a4,a4,0x1d
  1e:	01e71693          	slli	a3,a4,0x1e
  22:	40e68733          	sub	a4,a3,a4
  26:	0706                	slli	a4,a4,0x1
  28:	8f99                	sub	a5,a5,a4
  2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
  2c:	1fe406b7          	lui	a3,0x1fe40
  30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3db19>
  34:	41a70737          	lui	a4,0x41a70
  38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e54f>
  3c:	1702                	slli	a4,a4,0x20
  3e:	9736                	add	a4,a4,a3
  40:	02e79733          	mulh	a4,a5,a4
  44:	873d                	srai	a4,a4,0xf
  46:	43f7d693          	srai	a3,a5,0x3f
  4a:	8f15                	sub	a4,a4,a3
  4c:	66fd                	lui	a3,0x1f
  4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1d2bd>
  52:	02d706b3          	mul	a3,a4,a3
  56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
  58:	6691                	lui	a3,0x4
  5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x2147>
  5e:	02d787b3          	mul	a5,a5,a3
  62:	76fd                	lui	a3,0xfffff
  64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd48c>
  68:	02d70733          	mul	a4,a4,a3
  6c:	97ba                	add	a5,a5,a4
    if (x < 0)
  6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
  72:	17fd                	addi	a5,a5,-1
    *ctx = x;
  74:	e11c                	sd	a5,0(a0)
    return (x);
}
  76:	0007851b          	sext.w	a0,a5
  7a:	60a2                	ld	ra,8(sp)
  7c:	6402                	ld	s0,0(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret
        x += 0x7fffffff;
  82:	80000737          	lui	a4,0x80000
  86:	fff74713          	not	a4,a4
  8a:	97ba                	add	a5,a5,a4
  8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
  96:	00002517          	auipc	a0,0x2
  9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
  9e:	f63ff0ef          	jal	0 <do_rand>
}
  a2:	60a2                	ld	ra,8(sp)
  a4:	6402                	ld	s0,0(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <randstring>:

// generate a random string of the indicated length.
char *
randstring(char *buf, int n)
{
  aa:	7139                	addi	sp,sp,-64
  ac:	fc06                	sd	ra,56(sp)
  ae:	f822                	sd	s0,48(sp)
  b0:	e852                	sd	s4,16(sp)
  b2:	e456                	sd	s5,8(sp)
  b4:	0080                	addi	s0,sp,64
  b6:	8aaa                	mv	s5,a0
  b8:	8a2e                	mv	s4,a1
  for(int i = 0; i < n-1; i++) {
  ba:	4785                	li	a5,1
  bc:	06b7d163          	bge	a5,a1,11e <randstring+0x74>
  c0:	f426                	sd	s1,40(sp)
  c2:	f04a                	sd	s2,32(sp)
  c4:	ec4e                	sd	s3,24(sp)
  c6:	84aa                	mv	s1,a0
  c8:	00f50933          	add	s2,a0,a5
  cc:	ffe5879b          	addiw	a5,a1,-2
  d0:	1782                	slli	a5,a5,0x20
  d2:	9381                	srli	a5,a5,0x20
  d4:	993e                	add	s2,s2,a5
    buf[i] = "./abcdef"[(rand() >> 7) % 8];
  d6:	00001997          	auipc	s3,0x1
  da:	a0a98993          	addi	s3,s3,-1526 # ae0 <malloc+0xf2>
  de:	fb1ff0ef          	jal	8e <rand>
  e2:	4075579b          	sraiw	a5,a0,0x7
  e6:	41f5551b          	sraiw	a0,a0,0x1f
  ea:	01d5571b          	srliw	a4,a0,0x1d
  ee:	9fb9                	addw	a5,a5,a4
  f0:	8b9d                	andi	a5,a5,7
  f2:	9f99                	subw	a5,a5,a4
  f4:	97ce                	add	a5,a5,s3
  f6:	0007c783          	lbu	a5,0(a5)
  fa:	00f48023          	sb	a5,0(s1)
  for(int i = 0; i < n-1; i++) {
  fe:	0485                	addi	s1,s1,1
 100:	fd249fe3          	bne	s1,s2,de <randstring+0x34>
 104:	74a2                	ld	s1,40(sp)
 106:	7902                	ld	s2,32(sp)
 108:	69e2                	ld	s3,24(sp)
  }
  if(n > 0)
    buf[n-1] = '\0';
 10a:	9a56                	add	s4,s4,s5
 10c:	fe0a0fa3          	sb	zero,-1(s4)
  return buf;
}
 110:	8556                	mv	a0,s5
 112:	70e2                	ld	ra,56(sp)
 114:	7442                	ld	s0,48(sp)
 116:	6a42                	ld	s4,16(sp)
 118:	6aa2                	ld	s5,8(sp)
 11a:	6121                	addi	sp,sp,64
 11c:	8082                	ret
  if(n > 0)
 11e:	feb059e3          	blez	a1,110 <randstring+0x66>
 122:	b7e5                	j	10a <randstring+0x60>

0000000000000124 <main>:

int
main(int argc, char *argv[])
{
 124:	7179                	addi	sp,sp,-48
 126:	f406                	sd	ra,40(sp)
 128:	f022                	sd	s0,32(sp)
 12a:	1800                	addi	s0,sp,48
  int pid;
  int fds[2];

  // an insecure way of generating a random string, because xv6
  // doesn't have good source of randomness.
  rand_next = uptime();
 12c:	4a0000ef          	jal	5cc <uptime>
 130:	00002797          	auipc	a5,0x2
 134:	eca7b823          	sd	a0,-304(a5) # 2000 <rand_next>
  randstring(secret, 8);
 138:	45a1                	li	a1,8
 13a:	00002517          	auipc	a0,0x2
 13e:	ed650513          	addi	a0,a0,-298 # 2010 <secret>
 142:	f69ff0ef          	jal	aa <randstring>
  
  if((pid = fork()) < 0) {
 146:	3e6000ef          	jal	52c <fork>
 14a:	06054c63          	bltz	a0,1c2 <main+0x9e>
    printf("fork failed\n");
    exit(1);   
  }
  if(pid == 0) {
 14e:	c159                	beqz	a0,1d4 <main+0xb0>
    char *newargv[] = { "secret", secret, 0 };
    exec(newargv[0], newargv);
    printf("exec %s failed\n", newargv[0]);
    exit(1);
  } else {
    wait(0);  // wait for secret to exit
 150:	4501                	li	a0,0
 152:	3ea000ef          	jal	53c <wait>
    if(pipe(fds) < 0) {
 156:	fe840513          	addi	a0,s0,-24
 15a:	3ea000ef          	jal	544 <pipe>
 15e:	0a054863          	bltz	a0,20e <main+0xea>
      printf("pipe failed\n");
      exit(1);   
    }
    if((pid = fork()) < 0) {
 162:	3ca000ef          	jal	52c <fork>
 166:	0a054d63          	bltz	a0,220 <main+0xfc>
      printf("fork failed\n");
      exit(1);   
    }
    if(pid == 0) {
 16a:	c561                	beqz	a0,232 <main+0x10e>
      char *newargv[] = { "attack", 0 };
      exec(newargv[0], newargv);
      printf("exec %s failed\n", newargv[0]);
      exit(1);
    } else {
       close(fds[1]);
 16c:	fec42503          	lw	a0,-20(s0)
 170:	3ec000ef          	jal	55c <close>
      if(read(fds[0], output, 64) < 0) {
 174:	04000613          	li	a2,64
 178:	00002597          	auipc	a1,0x2
 17c:	ea858593          	addi	a1,a1,-344 # 2020 <output>
 180:	fe842503          	lw	a0,-24(s0)
 184:	3c8000ef          	jal	54c <read>
 188:	0e054763          	bltz	a0,276 <main+0x152>
        printf("FAIL; read failed; no secret\n");
        exit(1);
      }
      if(strcmp(secret, output) == 0) {
 18c:	00002597          	auipc	a1,0x2
 190:	e9458593          	addi	a1,a1,-364 # 2020 <output>
 194:	00002517          	auipc	a0,0x2
 198:	e7c50513          	addi	a0,a0,-388 # 2010 <secret>
 19c:	12c000ef          	jal	2c8 <strcmp>
 1a0:	0e051463          	bnez	a0,288 <main+0x164>
        printf("OK: secret is %s\n", output);
 1a4:	00002597          	auipc	a1,0x2
 1a8:	e7c58593          	addi	a1,a1,-388 # 2020 <output>
 1ac:	00001517          	auipc	a0,0x1
 1b0:	9a450513          	addi	a0,a0,-1628 # b50 <malloc+0x162>
 1b4:	782000ef          	jal	936 <printf>
      } else {
        printf("FAIL: no/incorrect secret\n");
      }
    }
  }
}
 1b8:	4501                	li	a0,0
 1ba:	70a2                	ld	ra,40(sp)
 1bc:	7402                	ld	s0,32(sp)
 1be:	6145                	addi	sp,sp,48
 1c0:	8082                	ret
    printf("fork failed\n");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	92e50513          	addi	a0,a0,-1746 # af0 <malloc+0x102>
 1ca:	76c000ef          	jal	936 <printf>
    exit(1);   
 1ce:	4505                	li	a0,1
 1d0:	364000ef          	jal	534 <exit>
    char *newargv[] = { "secret", secret, 0 };
 1d4:	00001517          	auipc	a0,0x1
 1d8:	92c50513          	addi	a0,a0,-1748 # b00 <malloc+0x112>
 1dc:	fca43823          	sd	a0,-48(s0)
 1e0:	00002797          	auipc	a5,0x2
 1e4:	e3078793          	addi	a5,a5,-464 # 2010 <secret>
 1e8:	fcf43c23          	sd	a5,-40(s0)
 1ec:	fe043023          	sd	zero,-32(s0)
    exec(newargv[0], newargv);
 1f0:	fd040593          	addi	a1,s0,-48
 1f4:	378000ef          	jal	56c <exec>
    printf("exec %s failed\n", newargv[0]);
 1f8:	fd043583          	ld	a1,-48(s0)
 1fc:	00001517          	auipc	a0,0x1
 200:	90c50513          	addi	a0,a0,-1780 # b08 <malloc+0x11a>
 204:	732000ef          	jal	936 <printf>
    exit(1);
 208:	4505                	li	a0,1
 20a:	32a000ef          	jal	534 <exit>
      printf("pipe failed\n");
 20e:	00001517          	auipc	a0,0x1
 212:	90a50513          	addi	a0,a0,-1782 # b18 <malloc+0x12a>
 216:	720000ef          	jal	936 <printf>
      exit(1);   
 21a:	4505                	li	a0,1
 21c:	318000ef          	jal	534 <exit>
      printf("fork failed\n");
 220:	00001517          	auipc	a0,0x1
 224:	8d050513          	addi	a0,a0,-1840 # af0 <malloc+0x102>
 228:	70e000ef          	jal	936 <printf>
      exit(1);   
 22c:	4505                	li	a0,1
 22e:	306000ef          	jal	534 <exit>
      close(fds[0]);
 232:	fe842503          	lw	a0,-24(s0)
 236:	326000ef          	jal	55c <close>
      close(2);
 23a:	4509                	li	a0,2
 23c:	320000ef          	jal	55c <close>
      dup(fds[1]);
 240:	fec42503          	lw	a0,-20(s0)
 244:	368000ef          	jal	5ac <dup>
      char *newargv[] = { "attack", 0 };
 248:	00001517          	auipc	a0,0x1
 24c:	8e050513          	addi	a0,a0,-1824 # b28 <malloc+0x13a>
 250:	fca43823          	sd	a0,-48(s0)
 254:	fc043c23          	sd	zero,-40(s0)
      exec(newargv[0], newargv);
 258:	fd040593          	addi	a1,s0,-48
 25c:	310000ef          	jal	56c <exec>
      printf("exec %s failed\n", newargv[0]);
 260:	fd043583          	ld	a1,-48(s0)
 264:	00001517          	auipc	a0,0x1
 268:	8a450513          	addi	a0,a0,-1884 # b08 <malloc+0x11a>
 26c:	6ca000ef          	jal	936 <printf>
      exit(1);
 270:	4505                	li	a0,1
 272:	2c2000ef          	jal	534 <exit>
        printf("FAIL; read failed; no secret\n");
 276:	00001517          	auipc	a0,0x1
 27a:	8ba50513          	addi	a0,a0,-1862 # b30 <malloc+0x142>
 27e:	6b8000ef          	jal	936 <printf>
        exit(1);
 282:	4505                	li	a0,1
 284:	2b0000ef          	jal	534 <exit>
        printf("FAIL: no/incorrect secret\n");
 288:	00001517          	auipc	a0,0x1
 28c:	8e050513          	addi	a0,a0,-1824 # b68 <malloc+0x17a>
 290:	6a6000ef          	jal	936 <printf>
 294:	b715                	j	1b8 <main+0x94>

0000000000000296 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 29e:	e87ff0ef          	jal	124 <main>
  exit(0);
 2a2:	4501                	li	a0,0
 2a4:	290000ef          	jal	534 <exit>

00000000000002a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b0:	87aa                	mv	a5,a0
 2b2:	0585                	addi	a1,a1,1
 2b4:	0785                	addi	a5,a5,1
 2b6:	fff5c703          	lbu	a4,-1(a1)
 2ba:	fee78fa3          	sb	a4,-1(a5)
 2be:	fb75                	bnez	a4,2b2 <strcpy+0xa>
    ;
  return os;
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2d0:	00054783          	lbu	a5,0(a0)
 2d4:	cb91                	beqz	a5,2e8 <strcmp+0x20>
 2d6:	0005c703          	lbu	a4,0(a1)
 2da:	00f71763          	bne	a4,a5,2e8 <strcmp+0x20>
    p++, q++;
 2de:	0505                	addi	a0,a0,1
 2e0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	fbe5                	bnez	a5,2d6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2e8:	0005c503          	lbu	a0,0(a1)
}
 2ec:	40a7853b          	subw	a0,a5,a0
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <strlen>:

uint
strlen(const char *s)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 300:	00054783          	lbu	a5,0(a0)
 304:	cf99                	beqz	a5,322 <strlen+0x2a>
 306:	0505                	addi	a0,a0,1
 308:	87aa                	mv	a5,a0
 30a:	86be                	mv	a3,a5
 30c:	0785                	addi	a5,a5,1
 30e:	fff7c703          	lbu	a4,-1(a5)
 312:	ff65                	bnez	a4,30a <strlen+0x12>
 314:	40a6853b          	subw	a0,a3,a0
 318:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  for(n = 0; s[n]; n++)
 322:	4501                	li	a0,0
 324:	bfdd                	j	31a <strlen+0x22>

0000000000000326 <memset>:

void*
memset(void *dst, int c, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 32e:	ca19                	beqz	a2,344 <memset+0x1e>
 330:	87aa                	mv	a5,a0
 332:	1602                	slli	a2,a2,0x20
 334:	9201                	srli	a2,a2,0x20
 336:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 33a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 33e:	0785                	addi	a5,a5,1
 340:	fee79de3          	bne	a5,a4,33a <memset+0x14>
  }
  return dst;
}
 344:	60a2                	ld	ra,8(sp)
 346:	6402                	ld	s0,0(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <strchr>:

char*
strchr(const char *s, char c)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  for(; *s; s++)
 354:	00054783          	lbu	a5,0(a0)
 358:	cf81                	beqz	a5,370 <strchr+0x24>
    if(*s == c)
 35a:	00f58763          	beq	a1,a5,368 <strchr+0x1c>
  for(; *s; s++)
 35e:	0505                	addi	a0,a0,1
 360:	00054783          	lbu	a5,0(a0)
 364:	fbfd                	bnez	a5,35a <strchr+0xe>
      return (char*)s;
  return 0;
 366:	4501                	li	a0,0
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  return 0;
 370:	4501                	li	a0,0
 372:	bfdd                	j	368 <strchr+0x1c>

0000000000000374 <gets>:

char*
gets(char *buf, int max)
{
 374:	7159                	addi	sp,sp,-112
 376:	f486                	sd	ra,104(sp)
 378:	f0a2                	sd	s0,96(sp)
 37a:	eca6                	sd	s1,88(sp)
 37c:	e8ca                	sd	s2,80(sp)
 37e:	e4ce                	sd	s3,72(sp)
 380:	e0d2                	sd	s4,64(sp)
 382:	fc56                	sd	s5,56(sp)
 384:	f85a                	sd	s6,48(sp)
 386:	f45e                	sd	s7,40(sp)
 388:	f062                	sd	s8,32(sp)
 38a:	ec66                	sd	s9,24(sp)
 38c:	e86a                	sd	s10,16(sp)
 38e:	1880                	addi	s0,sp,112
 390:	8caa                	mv	s9,a0
 392:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 394:	892a                	mv	s2,a0
 396:	4481                	li	s1,0
    cc = read(0, &c, 1);
 398:	f9f40b13          	addi	s6,s0,-97
 39c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 39e:	4ba9                	li	s7,10
 3a0:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 3a2:	8d26                	mv	s10,s1
 3a4:	0014899b          	addiw	s3,s1,1
 3a8:	84ce                	mv	s1,s3
 3aa:	0349d563          	bge	s3,s4,3d4 <gets+0x60>
    cc = read(0, &c, 1);
 3ae:	8656                	mv	a2,s5
 3b0:	85da                	mv	a1,s6
 3b2:	4501                	li	a0,0
 3b4:	198000ef          	jal	54c <read>
    if(cc < 1)
 3b8:	00a05e63          	blez	a0,3d4 <gets+0x60>
    buf[i++] = c;
 3bc:	f9f44783          	lbu	a5,-97(s0)
 3c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c4:	01778763          	beq	a5,s7,3d2 <gets+0x5e>
 3c8:	0905                	addi	s2,s2,1
 3ca:	fd879ce3          	bne	a5,s8,3a2 <gets+0x2e>
    buf[i++] = c;
 3ce:	8d4e                	mv	s10,s3
 3d0:	a011                	j	3d4 <gets+0x60>
 3d2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3d4:	9d66                	add	s10,s10,s9
 3d6:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3da:	8566                	mv	a0,s9
 3dc:	70a6                	ld	ra,104(sp)
 3de:	7406                	ld	s0,96(sp)
 3e0:	64e6                	ld	s1,88(sp)
 3e2:	6946                	ld	s2,80(sp)
 3e4:	69a6                	ld	s3,72(sp)
 3e6:	6a06                	ld	s4,64(sp)
 3e8:	7ae2                	ld	s5,56(sp)
 3ea:	7b42                	ld	s6,48(sp)
 3ec:	7ba2                	ld	s7,40(sp)
 3ee:	7c02                	ld	s8,32(sp)
 3f0:	6ce2                	ld	s9,24(sp)
 3f2:	6d42                	ld	s10,16(sp)
 3f4:	6165                	addi	sp,sp,112
 3f6:	8082                	ret

00000000000003f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f8:	1101                	addi	sp,sp,-32
 3fa:	ec06                	sd	ra,24(sp)
 3fc:	e822                	sd	s0,16(sp)
 3fe:	e04a                	sd	s2,0(sp)
 400:	1000                	addi	s0,sp,32
 402:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 404:	4581                	li	a1,0
 406:	16e000ef          	jal	574 <open>
  if(fd < 0)
 40a:	02054263          	bltz	a0,42e <stat+0x36>
 40e:	e426                	sd	s1,8(sp)
 410:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 412:	85ca                	mv	a1,s2
 414:	178000ef          	jal	58c <fstat>
 418:	892a                	mv	s2,a0
  close(fd);
 41a:	8526                	mv	a0,s1
 41c:	140000ef          	jal	55c <close>
  return r;
 420:	64a2                	ld	s1,8(sp)
}
 422:	854a                	mv	a0,s2
 424:	60e2                	ld	ra,24(sp)
 426:	6442                	ld	s0,16(sp)
 428:	6902                	ld	s2,0(sp)
 42a:	6105                	addi	sp,sp,32
 42c:	8082                	ret
    return -1;
 42e:	597d                	li	s2,-1
 430:	bfcd                	j	422 <stat+0x2a>

0000000000000432 <atoi>:

int
atoi(const char *s)
{
 432:	1141                	addi	sp,sp,-16
 434:	e406                	sd	ra,8(sp)
 436:	e022                	sd	s0,0(sp)
 438:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 43a:	00054683          	lbu	a3,0(a0)
 43e:	fd06879b          	addiw	a5,a3,-48
 442:	0ff7f793          	zext.b	a5,a5
 446:	4625                	li	a2,9
 448:	02f66963          	bltu	a2,a5,47a <atoi+0x48>
 44c:	872a                	mv	a4,a0
  n = 0;
 44e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 450:	0705                	addi	a4,a4,1 # ffffffff80000001 <base+0xffffffff7fffdfa1>
 452:	0025179b          	slliw	a5,a0,0x2
 456:	9fa9                	addw	a5,a5,a0
 458:	0017979b          	slliw	a5,a5,0x1
 45c:	9fb5                	addw	a5,a5,a3
 45e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 462:	00074683          	lbu	a3,0(a4)
 466:	fd06879b          	addiw	a5,a3,-48
 46a:	0ff7f793          	zext.b	a5,a5
 46e:	fef671e3          	bgeu	a2,a5,450 <atoi+0x1e>
  return n;
}
 472:	60a2                	ld	ra,8(sp)
 474:	6402                	ld	s0,0(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
  n = 0;
 47a:	4501                	li	a0,0
 47c:	bfdd                	j	472 <atoi+0x40>

000000000000047e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47e:	1141                	addi	sp,sp,-16
 480:	e406                	sd	ra,8(sp)
 482:	e022                	sd	s0,0(sp)
 484:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 486:	02b57563          	bgeu	a0,a1,4b0 <memmove+0x32>
    while(n-- > 0)
 48a:	00c05f63          	blez	a2,4a8 <memmove+0x2a>
 48e:	1602                	slli	a2,a2,0x20
 490:	9201                	srli	a2,a2,0x20
 492:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 496:	872a                	mv	a4,a0
      *dst++ = *src++;
 498:	0585                	addi	a1,a1,1
 49a:	0705                	addi	a4,a4,1
 49c:	fff5c683          	lbu	a3,-1(a1)
 4a0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a4:	fee79ae3          	bne	a5,a4,498 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4a8:	60a2                	ld	ra,8(sp)
 4aa:	6402                	ld	s0,0(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret
    dst += n;
 4b0:	00c50733          	add	a4,a0,a2
    src += n;
 4b4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b6:	fec059e3          	blez	a2,4a8 <memmove+0x2a>
 4ba:	fff6079b          	addiw	a5,a2,-1
 4be:	1782                	slli	a5,a5,0x20
 4c0:	9381                	srli	a5,a5,0x20
 4c2:	fff7c793          	not	a5,a5
 4c6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4c8:	15fd                	addi	a1,a1,-1
 4ca:	177d                	addi	a4,a4,-1
 4cc:	0005c683          	lbu	a3,0(a1)
 4d0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4d4:	fef71ae3          	bne	a4,a5,4c8 <memmove+0x4a>
 4d8:	bfc1                	j	4a8 <memmove+0x2a>

00000000000004da <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4da:	1141                	addi	sp,sp,-16
 4dc:	e406                	sd	ra,8(sp)
 4de:	e022                	sd	s0,0(sp)
 4e0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4e2:	ca0d                	beqz	a2,514 <memcmp+0x3a>
 4e4:	fff6069b          	addiw	a3,a2,-1
 4e8:	1682                	slli	a3,a3,0x20
 4ea:	9281                	srli	a3,a3,0x20
 4ec:	0685                	addi	a3,a3,1
 4ee:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4f0:	00054783          	lbu	a5,0(a0)
 4f4:	0005c703          	lbu	a4,0(a1)
 4f8:	00e79863          	bne	a5,a4,508 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4fc:	0505                	addi	a0,a0,1
    p2++;
 4fe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 500:	fed518e3          	bne	a0,a3,4f0 <memcmp+0x16>
  }
  return 0;
 504:	4501                	li	a0,0
 506:	a019                	j	50c <memcmp+0x32>
      return *p1 - *p2;
 508:	40e7853b          	subw	a0,a5,a4
}
 50c:	60a2                	ld	ra,8(sp)
 50e:	6402                	ld	s0,0(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret
  return 0;
 514:	4501                	li	a0,0
 516:	bfdd                	j	50c <memcmp+0x32>

0000000000000518 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 518:	1141                	addi	sp,sp,-16
 51a:	e406                	sd	ra,8(sp)
 51c:	e022                	sd	s0,0(sp)
 51e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 520:	f5fff0ef          	jal	47e <memmove>
}
 524:	60a2                	ld	ra,8(sp)
 526:	6402                	ld	s0,0(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret

000000000000052c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 52c:	4885                	li	a7,1
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <exit>:
.global exit
exit:
 li a7, SYS_exit
 534:	4889                	li	a7,2
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <wait>:
.global wait
wait:
 li a7, SYS_wait
 53c:	488d                	li	a7,3
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 544:	4891                	li	a7,4
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <read>:
.global read
read:
 li a7, SYS_read
 54c:	4895                	li	a7,5
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <write>:
.global write
write:
 li a7, SYS_write
 554:	48c1                	li	a7,16
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <close>:
.global close
close:
 li a7, SYS_close
 55c:	48d5                	li	a7,21
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <kill>:
.global kill
kill:
 li a7, SYS_kill
 564:	4899                	li	a7,6
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exec>:
.global exec
exec:
 li a7, SYS_exec
 56c:	489d                	li	a7,7
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <open>:
.global open
open:
 li a7, SYS_open
 574:	48bd                	li	a7,15
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 57c:	48c5                	li	a7,17
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 584:	48c9                	li	a7,18
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 58c:	48a1                	li	a7,8
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <link>:
.global link
link:
 li a7, SYS_link
 594:	48cd                	li	a7,19
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 59c:	48d1                	li	a7,20
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a4:	48a5                	li	a7,9
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ac:	48a9                	li	a7,10
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b4:	48ad                	li	a7,11
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5bc:	48b1                	li	a7,12
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5c4:	48b5                	li	a7,13
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5cc:	48b9                	li	a7,14
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d4:	1101                	addi	sp,sp,-32
 5d6:	ec06                	sd	ra,24(sp)
 5d8:	e822                	sd	s0,16(sp)
 5da:	1000                	addi	s0,sp,32
 5dc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e0:	4605                	li	a2,1
 5e2:	fef40593          	addi	a1,s0,-17
 5e6:	f6fff0ef          	jal	554 <write>
}
 5ea:	60e2                	ld	ra,24(sp)
 5ec:	6442                	ld	s0,16(sp)
 5ee:	6105                	addi	sp,sp,32
 5f0:	8082                	ret

00000000000005f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f2:	7139                	addi	sp,sp,-64
 5f4:	fc06                	sd	ra,56(sp)
 5f6:	f822                	sd	s0,48(sp)
 5f8:	f426                	sd	s1,40(sp)
 5fa:	f04a                	sd	s2,32(sp)
 5fc:	ec4e                	sd	s3,24(sp)
 5fe:	0080                	addi	s0,sp,64
 600:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 602:	c299                	beqz	a3,608 <printint+0x16>
 604:	0605ce63          	bltz	a1,680 <printint+0x8e>
  neg = 0;
 608:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 60a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 60e:	869a                	mv	a3,t1
  i = 0;
 610:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 612:	00000817          	auipc	a6,0x0
 616:	57e80813          	addi	a6,a6,1406 # b90 <digits>
 61a:	88be                	mv	a7,a5
 61c:	0017851b          	addiw	a0,a5,1
 620:	87aa                	mv	a5,a0
 622:	02c5f73b          	remuw	a4,a1,a2
 626:	1702                	slli	a4,a4,0x20
 628:	9301                	srli	a4,a4,0x20
 62a:	9742                	add	a4,a4,a6
 62c:	00074703          	lbu	a4,0(a4)
 630:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 634:	872e                	mv	a4,a1
 636:	02c5d5bb          	divuw	a1,a1,a2
 63a:	0685                	addi	a3,a3,1
 63c:	fcc77fe3          	bgeu	a4,a2,61a <printint+0x28>
  if(neg)
 640:	000e0c63          	beqz	t3,658 <printint+0x66>
    buf[i++] = '-';
 644:	fd050793          	addi	a5,a0,-48
 648:	00878533          	add	a0,a5,s0
 64c:	02d00793          	li	a5,45
 650:	fef50823          	sb	a5,-16(a0)
 654:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 658:	fff7899b          	addiw	s3,a5,-1
 65c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 660:	fff4c583          	lbu	a1,-1(s1)
 664:	854a                	mv	a0,s2
 666:	f6fff0ef          	jal	5d4 <putc>
  while(--i >= 0)
 66a:	39fd                	addiw	s3,s3,-1
 66c:	14fd                	addi	s1,s1,-1
 66e:	fe09d9e3          	bgez	s3,660 <printint+0x6e>
}
 672:	70e2                	ld	ra,56(sp)
 674:	7442                	ld	s0,48(sp)
 676:	74a2                	ld	s1,40(sp)
 678:	7902                	ld	s2,32(sp)
 67a:	69e2                	ld	s3,24(sp)
 67c:	6121                	addi	sp,sp,64
 67e:	8082                	ret
    x = -xx;
 680:	40b005bb          	negw	a1,a1
    neg = 1;
 684:	4e05                	li	t3,1
    x = -xx;
 686:	b751                	j	60a <printint+0x18>

0000000000000688 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 688:	711d                	addi	sp,sp,-96
 68a:	ec86                	sd	ra,88(sp)
 68c:	e8a2                	sd	s0,80(sp)
 68e:	e4a6                	sd	s1,72(sp)
 690:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 692:	0005c483          	lbu	s1,0(a1)
 696:	26048663          	beqz	s1,902 <vprintf+0x27a>
 69a:	e0ca                	sd	s2,64(sp)
 69c:	fc4e                	sd	s3,56(sp)
 69e:	f852                	sd	s4,48(sp)
 6a0:	f456                	sd	s5,40(sp)
 6a2:	f05a                	sd	s6,32(sp)
 6a4:	ec5e                	sd	s7,24(sp)
 6a6:	e862                	sd	s8,16(sp)
 6a8:	e466                	sd	s9,8(sp)
 6aa:	8b2a                	mv	s6,a0
 6ac:	8a2e                	mv	s4,a1
 6ae:	8bb2                	mv	s7,a2
  state = 0;
 6b0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6b2:	4901                	li	s2,0
 6b4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6b6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ba:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6be:	06c00c93          	li	s9,108
 6c2:	a00d                	j	6e4 <vprintf+0x5c>
        putc(fd, c0);
 6c4:	85a6                	mv	a1,s1
 6c6:	855a                	mv	a0,s6
 6c8:	f0dff0ef          	jal	5d4 <putc>
 6cc:	a019                	j	6d2 <vprintf+0x4a>
    } else if(state == '%'){
 6ce:	03598363          	beq	s3,s5,6f4 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6d2:	0019079b          	addiw	a5,s2,1
 6d6:	893e                	mv	s2,a5
 6d8:	873e                	mv	a4,a5
 6da:	97d2                	add	a5,a5,s4
 6dc:	0007c483          	lbu	s1,0(a5)
 6e0:	20048963          	beqz	s1,8f2 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 6e4:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6e8:	fe0993e3          	bnez	s3,6ce <vprintf+0x46>
      if(c0 == '%'){
 6ec:	fd579ce3          	bne	a5,s5,6c4 <vprintf+0x3c>
        state = '%';
 6f0:	89be                	mv	s3,a5
 6f2:	b7c5                	j	6d2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6f4:	00ea06b3          	add	a3,s4,a4
 6f8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6fc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6fe:	c681                	beqz	a3,706 <vprintf+0x7e>
 700:	9752                	add	a4,a4,s4
 702:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 706:	03878e63          	beq	a5,s8,742 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 70a:	05978863          	beq	a5,s9,75a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 70e:	07500713          	li	a4,117
 712:	0ee78263          	beq	a5,a4,7f6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 716:	07800713          	li	a4,120
 71a:	12e78463          	beq	a5,a4,842 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 71e:	07000713          	li	a4,112
 722:	14e78963          	beq	a5,a4,874 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 726:	07300713          	li	a4,115
 72a:	18e78863          	beq	a5,a4,8ba <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 72e:	02500713          	li	a4,37
 732:	04e79463          	bne	a5,a4,77a <vprintf+0xf2>
        putc(fd, '%');
 736:	85ba                	mv	a1,a4
 738:	855a                	mv	a0,s6
 73a:	e9bff0ef          	jal	5d4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 73e:	4981                	li	s3,0
 740:	bf49                	j	6d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 742:	008b8493          	addi	s1,s7,8
 746:	4685                	li	a3,1
 748:	4629                	li	a2,10
 74a:	000ba583          	lw	a1,0(s7)
 74e:	855a                	mv	a0,s6
 750:	ea3ff0ef          	jal	5f2 <printint>
 754:	8ba6                	mv	s7,s1
      state = 0;
 756:	4981                	li	s3,0
 758:	bfad                	j	6d2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 75a:	06400793          	li	a5,100
 75e:	02f68963          	beq	a3,a5,790 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 762:	06c00793          	li	a5,108
 766:	04f68263          	beq	a3,a5,7aa <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 76a:	07500793          	li	a5,117
 76e:	0af68063          	beq	a3,a5,80e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 772:	07800793          	li	a5,120
 776:	0ef68263          	beq	a3,a5,85a <vprintf+0x1d2>
        putc(fd, '%');
 77a:	02500593          	li	a1,37
 77e:	855a                	mv	a0,s6
 780:	e55ff0ef          	jal	5d4 <putc>
        putc(fd, c0);
 784:	85a6                	mv	a1,s1
 786:	855a                	mv	a0,s6
 788:	e4dff0ef          	jal	5d4 <putc>
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b791                	j	6d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 790:	008b8493          	addi	s1,s7,8
 794:	4685                	li	a3,1
 796:	4629                	li	a2,10
 798:	000ba583          	lw	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	e55ff0ef          	jal	5f2 <printint>
        i += 1;
 7a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a4:	8ba6                	mv	s7,s1
      state = 0;
 7a6:	4981                	li	s3,0
        i += 1;
 7a8:	b72d                	j	6d2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7aa:	06400793          	li	a5,100
 7ae:	02f60763          	beq	a2,a5,7dc <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7b2:	07500793          	li	a5,117
 7b6:	06f60963          	beq	a2,a5,828 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ba:	07800793          	li	a5,120
 7be:	faf61ee3          	bne	a2,a5,77a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c2:	008b8493          	addi	s1,s7,8
 7c6:	4681                	li	a3,0
 7c8:	4641                	li	a2,16
 7ca:	000ba583          	lw	a1,0(s7)
 7ce:	855a                	mv	a0,s6
 7d0:	e23ff0ef          	jal	5f2 <printint>
        i += 2;
 7d4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d6:	8ba6                	mv	s7,s1
      state = 0;
 7d8:	4981                	li	s3,0
        i += 2;
 7da:	bde5                	j	6d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7dc:	008b8493          	addi	s1,s7,8
 7e0:	4685                	li	a3,1
 7e2:	4629                	li	a2,10
 7e4:	000ba583          	lw	a1,0(s7)
 7e8:	855a                	mv	a0,s6
 7ea:	e09ff0ef          	jal	5f2 <printint>
        i += 2;
 7ee:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f0:	8ba6                	mv	s7,s1
      state = 0;
 7f2:	4981                	li	s3,0
        i += 2;
 7f4:	bdf9                	j	6d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7f6:	008b8493          	addi	s1,s7,8
 7fa:	4681                	li	a3,0
 7fc:	4629                	li	a2,10
 7fe:	000ba583          	lw	a1,0(s7)
 802:	855a                	mv	a0,s6
 804:	defff0ef          	jal	5f2 <printint>
 808:	8ba6                	mv	s7,s1
      state = 0;
 80a:	4981                	li	s3,0
 80c:	b5d9                	j	6d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80e:	008b8493          	addi	s1,s7,8
 812:	4681                	li	a3,0
 814:	4629                	li	a2,10
 816:	000ba583          	lw	a1,0(s7)
 81a:	855a                	mv	a0,s6
 81c:	dd7ff0ef          	jal	5f2 <printint>
        i += 1;
 820:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 822:	8ba6                	mv	s7,s1
      state = 0;
 824:	4981                	li	s3,0
        i += 1;
 826:	b575                	j	6d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 828:	008b8493          	addi	s1,s7,8
 82c:	4681                	li	a3,0
 82e:	4629                	li	a2,10
 830:	000ba583          	lw	a1,0(s7)
 834:	855a                	mv	a0,s6
 836:	dbdff0ef          	jal	5f2 <printint>
        i += 2;
 83a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 83c:	8ba6                	mv	s7,s1
      state = 0;
 83e:	4981                	li	s3,0
        i += 2;
 840:	bd49                	j	6d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 842:	008b8493          	addi	s1,s7,8
 846:	4681                	li	a3,0
 848:	4641                	li	a2,16
 84a:	000ba583          	lw	a1,0(s7)
 84e:	855a                	mv	a0,s6
 850:	da3ff0ef          	jal	5f2 <printint>
 854:	8ba6                	mv	s7,s1
      state = 0;
 856:	4981                	li	s3,0
 858:	bdad                	j	6d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 85a:	008b8493          	addi	s1,s7,8
 85e:	4681                	li	a3,0
 860:	4641                	li	a2,16
 862:	000ba583          	lw	a1,0(s7)
 866:	855a                	mv	a0,s6
 868:	d8bff0ef          	jal	5f2 <printint>
        i += 1;
 86c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 86e:	8ba6                	mv	s7,s1
      state = 0;
 870:	4981                	li	s3,0
        i += 1;
 872:	b585                	j	6d2 <vprintf+0x4a>
 874:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 876:	008b8d13          	addi	s10,s7,8
 87a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 87e:	03000593          	li	a1,48
 882:	855a                	mv	a0,s6
 884:	d51ff0ef          	jal	5d4 <putc>
  putc(fd, 'x');
 888:	07800593          	li	a1,120
 88c:	855a                	mv	a0,s6
 88e:	d47ff0ef          	jal	5d4 <putc>
 892:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 894:	00000b97          	auipc	s7,0x0
 898:	2fcb8b93          	addi	s7,s7,764 # b90 <digits>
 89c:	03c9d793          	srli	a5,s3,0x3c
 8a0:	97de                	add	a5,a5,s7
 8a2:	0007c583          	lbu	a1,0(a5)
 8a6:	855a                	mv	a0,s6
 8a8:	d2dff0ef          	jal	5d4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8ac:	0992                	slli	s3,s3,0x4
 8ae:	34fd                	addiw	s1,s1,-1
 8b0:	f4f5                	bnez	s1,89c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8b2:	8bea                	mv	s7,s10
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	6d02                	ld	s10,0(sp)
 8b8:	bd29                	j	6d2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8ba:	008b8993          	addi	s3,s7,8
 8be:	000bb483          	ld	s1,0(s7)
 8c2:	cc91                	beqz	s1,8de <vprintf+0x256>
        for(; *s; s++)
 8c4:	0004c583          	lbu	a1,0(s1)
 8c8:	c195                	beqz	a1,8ec <vprintf+0x264>
          putc(fd, *s);
 8ca:	855a                	mv	a0,s6
 8cc:	d09ff0ef          	jal	5d4 <putc>
        for(; *s; s++)
 8d0:	0485                	addi	s1,s1,1
 8d2:	0004c583          	lbu	a1,0(s1)
 8d6:	f9f5                	bnez	a1,8ca <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8d8:	8bce                	mv	s7,s3
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	bbdd                	j	6d2 <vprintf+0x4a>
          s = "(null)";
 8de:	00000497          	auipc	s1,0x0
 8e2:	2aa48493          	addi	s1,s1,682 # b88 <malloc+0x19a>
        for(; *s; s++)
 8e6:	02800593          	li	a1,40
 8ea:	b7c5                	j	8ca <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8ec:	8bce                	mv	s7,s3
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	b3cd                	j	6d2 <vprintf+0x4a>
 8f2:	6906                	ld	s2,64(sp)
 8f4:	79e2                	ld	s3,56(sp)
 8f6:	7a42                	ld	s4,48(sp)
 8f8:	7aa2                	ld	s5,40(sp)
 8fa:	7b02                	ld	s6,32(sp)
 8fc:	6be2                	ld	s7,24(sp)
 8fe:	6c42                	ld	s8,16(sp)
 900:	6ca2                	ld	s9,8(sp)
    }
  }
}
 902:	60e6                	ld	ra,88(sp)
 904:	6446                	ld	s0,80(sp)
 906:	64a6                	ld	s1,72(sp)
 908:	6125                	addi	sp,sp,96
 90a:	8082                	ret

000000000000090c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90c:	715d                	addi	sp,sp,-80
 90e:	ec06                	sd	ra,24(sp)
 910:	e822                	sd	s0,16(sp)
 912:	1000                	addi	s0,sp,32
 914:	e010                	sd	a2,0(s0)
 916:	e414                	sd	a3,8(s0)
 918:	e818                	sd	a4,16(s0)
 91a:	ec1c                	sd	a5,24(s0)
 91c:	03043023          	sd	a6,32(s0)
 920:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 924:	8622                	mv	a2,s0
 926:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 92a:	d5fff0ef          	jal	688 <vprintf>
}
 92e:	60e2                	ld	ra,24(sp)
 930:	6442                	ld	s0,16(sp)
 932:	6161                	addi	sp,sp,80
 934:	8082                	ret

0000000000000936 <printf>:

void
printf(const char *fmt, ...)
{
 936:	711d                	addi	sp,sp,-96
 938:	ec06                	sd	ra,24(sp)
 93a:	e822                	sd	s0,16(sp)
 93c:	1000                	addi	s0,sp,32
 93e:	e40c                	sd	a1,8(s0)
 940:	e810                	sd	a2,16(s0)
 942:	ec14                	sd	a3,24(s0)
 944:	f018                	sd	a4,32(s0)
 946:	f41c                	sd	a5,40(s0)
 948:	03043823          	sd	a6,48(s0)
 94c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 950:	00840613          	addi	a2,s0,8
 954:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 958:	85aa                	mv	a1,a0
 95a:	4505                	li	a0,1
 95c:	d2dff0ef          	jal	688 <vprintf>
}
 960:	60e2                	ld	ra,24(sp)
 962:	6442                	ld	s0,16(sp)
 964:	6125                	addi	sp,sp,96
 966:	8082                	ret

0000000000000968 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 968:	1141                	addi	sp,sp,-16
 96a:	e406                	sd	ra,8(sp)
 96c:	e022                	sd	s0,0(sp)
 96e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 970:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 974:	00001797          	auipc	a5,0x1
 978:	6a47b783          	ld	a5,1700(a5) # 2018 <freep>
 97c:	a02d                	j	9a6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 97e:	4618                	lw	a4,8(a2)
 980:	9f2d                	addw	a4,a4,a1
 982:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	6398                	ld	a4,0(a5)
 988:	6310                	ld	a2,0(a4)
 98a:	a83d                	j	9c8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98c:	ff852703          	lw	a4,-8(a0)
 990:	9f31                	addw	a4,a4,a2
 992:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 994:	ff053683          	ld	a3,-16(a0)
 998:	a091                	j	9dc <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99a:	6398                	ld	a4,0(a5)
 99c:	00e7e463          	bltu	a5,a4,9a4 <free+0x3c>
 9a0:	00e6ea63          	bltu	a3,a4,9b4 <free+0x4c>
{
 9a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a6:	fed7fae3          	bgeu	a5,a3,99a <free+0x32>
 9aa:	6398                	ld	a4,0(a5)
 9ac:	00e6e463          	bltu	a3,a4,9b4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b0:	fee7eae3          	bltu	a5,a4,9a4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9b4:	ff852583          	lw	a1,-8(a0)
 9b8:	6390                	ld	a2,0(a5)
 9ba:	02059813          	slli	a6,a1,0x20
 9be:	01c85713          	srli	a4,a6,0x1c
 9c2:	9736                	add	a4,a4,a3
 9c4:	fae60de3          	beq	a2,a4,97e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9cc:	4790                	lw	a2,8(a5)
 9ce:	02061593          	slli	a1,a2,0x20
 9d2:	01c5d713          	srli	a4,a1,0x1c
 9d6:	973e                	add	a4,a4,a5
 9d8:	fae68ae3          	beq	a3,a4,98c <free+0x24>
    p->s.ptr = bp->s.ptr;
 9dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9de:	00001717          	auipc	a4,0x1
 9e2:	62f73d23          	sd	a5,1594(a4) # 2018 <freep>
}
 9e6:	60a2                	ld	ra,8(sp)
 9e8:	6402                	ld	s0,0(sp)
 9ea:	0141                	addi	sp,sp,16
 9ec:	8082                	ret

00000000000009ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ee:	7139                	addi	sp,sp,-64
 9f0:	fc06                	sd	ra,56(sp)
 9f2:	f822                	sd	s0,48(sp)
 9f4:	f04a                	sd	s2,32(sp)
 9f6:	ec4e                	sd	s3,24(sp)
 9f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fa:	02051993          	slli	s3,a0,0x20
 9fe:	0209d993          	srli	s3,s3,0x20
 a02:	09bd                	addi	s3,s3,15
 a04:	0049d993          	srli	s3,s3,0x4
 a08:	2985                	addiw	s3,s3,1
 a0a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a0c:	00001517          	auipc	a0,0x1
 a10:	60c53503          	ld	a0,1548(a0) # 2018 <freep>
 a14:	c905                	beqz	a0,a44 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a16:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a18:	4798                	lw	a4,8(a5)
 a1a:	09377663          	bgeu	a4,s3,aa6 <malloc+0xb8>
 a1e:	f426                	sd	s1,40(sp)
 a20:	e852                	sd	s4,16(sp)
 a22:	e456                	sd	s5,8(sp)
 a24:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a26:	8a4e                	mv	s4,s3
 a28:	6705                	lui	a4,0x1
 a2a:	00e9f363          	bgeu	s3,a4,a30 <malloc+0x42>
 a2e:	6a05                	lui	s4,0x1
 a30:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a34:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a38:	00001497          	auipc	s1,0x1
 a3c:	5e048493          	addi	s1,s1,1504 # 2018 <freep>
  if(p == (char*)-1)
 a40:	5afd                	li	s5,-1
 a42:	a83d                	j	a80 <malloc+0x92>
 a44:	f426                	sd	s1,40(sp)
 a46:	e852                	sd	s4,16(sp)
 a48:	e456                	sd	s5,8(sp)
 a4a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a4c:	00001797          	auipc	a5,0x1
 a50:	61478793          	addi	a5,a5,1556 # 2060 <base>
 a54:	00001717          	auipc	a4,0x1
 a58:	5cf73223          	sd	a5,1476(a4) # 2018 <freep>
 a5c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a5e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a62:	b7d1                	j	a26 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a64:	6398                	ld	a4,0(a5)
 a66:	e118                	sd	a4,0(a0)
 a68:	a899                	j	abe <malloc+0xd0>
  hp->s.size = nu;
 a6a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a6e:	0541                	addi	a0,a0,16
 a70:	ef9ff0ef          	jal	968 <free>
  return freep;
 a74:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a76:	c125                	beqz	a0,ad6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a78:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7a:	4798                	lw	a4,8(a5)
 a7c:	03277163          	bgeu	a4,s2,a9e <malloc+0xb0>
    if(p == freep)
 a80:	6098                	ld	a4,0(s1)
 a82:	853e                	mv	a0,a5
 a84:	fef71ae3          	bne	a4,a5,a78 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a88:	8552                	mv	a0,s4
 a8a:	b33ff0ef          	jal	5bc <sbrk>
  if(p == (char*)-1)
 a8e:	fd551ee3          	bne	a0,s5,a6a <malloc+0x7c>
        return 0;
 a92:	4501                	li	a0,0
 a94:	74a2                	ld	s1,40(sp)
 a96:	6a42                	ld	s4,16(sp)
 a98:	6aa2                	ld	s5,8(sp)
 a9a:	6b02                	ld	s6,0(sp)
 a9c:	a03d                	j	aca <malloc+0xdc>
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	6a42                	ld	s4,16(sp)
 aa2:	6aa2                	ld	s5,8(sp)
 aa4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aa6:	fae90fe3          	beq	s2,a4,a64 <malloc+0x76>
        p->s.size -= nunits;
 aaa:	4137073b          	subw	a4,a4,s3
 aae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab0:	02071693          	slli	a3,a4,0x20
 ab4:	01c6d713          	srli	a4,a3,0x1c
 ab8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 abe:	00001717          	auipc	a4,0x1
 ac2:	54a73d23          	sd	a0,1370(a4) # 2018 <freep>
      return (void*)(p + 1);
 ac6:	01078513          	addi	a0,a5,16
  }
}
 aca:	70e2                	ld	ra,56(sp)
 acc:	7442                	ld	s0,48(sp)
 ace:	7902                	ld	s2,32(sp)
 ad0:	69e2                	ld	s3,24(sp)
 ad2:	6121                	addi	sp,sp,64
 ad4:	8082                	ret
 ad6:	74a2                	ld	s1,40(sp)
 ad8:	6a42                	ld	s4,16(sp)
 ada:	6aa2                	ld	s5,8(sp)
 adc:	6b02                	ld	s6,0(sp)
 ade:	b7f5                	j	aca <malloc+0xdc>
