
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	00001917          	auipc	s2,0x1
  18:	ffc90913          	addi	s2,s2,-4 # 1010 <buf>
  1c:	20000a13          	li	s4,512
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	384000ef          	jal	3ac <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	37c000ef          	jal	3b4 <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	92058593          	addi	a1,a1,-1760 # 960 <malloc+0xf6>
  48:	4509                	li	a0,2
  4a:	73e000ef          	jal	788 <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	344000ef          	jal	394 <exit>
    }
  }
  if(n < 0){
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	90e58593          	addi	a1,a1,-1778 # 978 <malloc+0x10e>
  72:	4509                	li	a0,2
  74:	714000ef          	jal	788 <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	31a000ef          	jal	394 <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	328000ef          	jal	3d4 <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	300000ef          	jal	3bc <close>
  for(i = 1; i < argc; i++){
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	2cc000ef          	jal	394 <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2ba000ef          	jal	394 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	8ae58593          	addi	a1,a1,-1874 # 990 <malloc+0x126>
  ea:	4509                	li	a0,2
  ec:	69c000ef          	jal	788 <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	2a2000ef          	jal	394 <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  fe:	f81ff0ef          	jal	7e <main>
  exit(0);
 102:	4501                	li	a0,0
 104:	290000ef          	jal	394 <exit>

0000000000000108 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 110:	87aa                	mv	a5,a0
 112:	0585                	addi	a1,a1,1
 114:	0785                	addi	a5,a5,1
 116:	fff5c703          	lbu	a4,-1(a1)
 11a:	fee78fa3          	sb	a4,-1(a5)
 11e:	fb75                	bnez	a4,112 <strcpy+0xa>
    ;
  return os;
}
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	cb91                	beqz	a5,148 <strcmp+0x20>
 136:	0005c703          	lbu	a4,0(a1)
 13a:	00f71763          	bne	a4,a5,148 <strcmp+0x20>
    p++, q++;
 13e:	0505                	addi	a0,a0,1
 140:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 142:	00054783          	lbu	a5,0(a0)
 146:	fbe5                	bnez	a5,136 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 148:	0005c503          	lbu	a0,0(a1)
}
 14c:	40a7853b          	subw	a0,a5,a0
 150:	60a2                	ld	ra,8(sp)
 152:	6402                	ld	s0,0(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e406                	sd	ra,8(sp)
 15c:	e022                	sd	s0,0(sp)
 15e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf99                	beqz	a5,182 <strlen+0x2a>
 166:	0505                	addi	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	86be                	mv	a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x12>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 17a:	60a2                	ld	ra,8(sp)
 17c:	6402                	ld	s0,0(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
  for(n = 0; s[n]; n++)
 182:	4501                	li	a0,0
 184:	bfdd                	j	17a <strlen+0x22>

0000000000000186 <memset>:

void*
memset(void *dst, int c, uint n)
{
 186:	1141                	addi	sp,sp,-16
 188:	e406                	sd	ra,8(sp)
 18a:	e022                	sd	s0,0(sp)
 18c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18e:	ca19                	beqz	a2,1a4 <memset+0x1e>
 190:	87aa                	mv	a5,a0
 192:	1602                	slli	a2,a2,0x20
 194:	9201                	srli	a2,a2,0x20
 196:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19e:	0785                	addi	a5,a5,1
 1a0:	fee79de3          	bne	a5,a4,19a <memset+0x14>
  }
  return dst;
}
 1a4:	60a2                	ld	ra,8(sp)
 1a6:	6402                	ld	s0,0(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	cf81                	beqz	a5,1d0 <strchr+0x24>
    if(*s == c)
 1ba:	00f58763          	beq	a1,a5,1c8 <strchr+0x1c>
  for(; *s; s++)
 1be:	0505                	addi	a0,a0,1
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	fbfd                	bnez	a5,1ba <strchr+0xe>
      return (char*)s;
  return 0;
 1c6:	4501                	li	a0,0
}
 1c8:	60a2                	ld	ra,8(sp)
 1ca:	6402                	ld	s0,0(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  return 0;
 1d0:	4501                	li	a0,0
 1d2:	bfdd                	j	1c8 <strchr+0x1c>

00000000000001d4 <gets>:

char*
gets(char *buf, int max)
{
 1d4:	7159                	addi	sp,sp,-112
 1d6:	f486                	sd	ra,104(sp)
 1d8:	f0a2                	sd	s0,96(sp)
 1da:	eca6                	sd	s1,88(sp)
 1dc:	e8ca                	sd	s2,80(sp)
 1de:	e4ce                	sd	s3,72(sp)
 1e0:	e0d2                	sd	s4,64(sp)
 1e2:	fc56                	sd	s5,56(sp)
 1e4:	f85a                	sd	s6,48(sp)
 1e6:	f45e                	sd	s7,40(sp)
 1e8:	f062                	sd	s8,32(sp)
 1ea:	ec66                	sd	s9,24(sp)
 1ec:	e86a                	sd	s10,16(sp)
 1ee:	1880                	addi	s0,sp,112
 1f0:	8caa                	mv	s9,a0
 1f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f4:	892a                	mv	s2,a0
 1f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f8:	f9f40b13          	addi	s6,s0,-97
 1fc:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fe:	4ba9                	li	s7,10
 200:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 202:	8d26                	mv	s10,s1
 204:	0014899b          	addiw	s3,s1,1
 208:	84ce                	mv	s1,s3
 20a:	0349d563          	bge	s3,s4,234 <gets+0x60>
    cc = read(0, &c, 1);
 20e:	8656                	mv	a2,s5
 210:	85da                	mv	a1,s6
 212:	4501                	li	a0,0
 214:	198000ef          	jal	3ac <read>
    if(cc < 1)
 218:	00a05e63          	blez	a0,234 <gets+0x60>
    buf[i++] = c;
 21c:	f9f44783          	lbu	a5,-97(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	01778763          	beq	a5,s7,232 <gets+0x5e>
 228:	0905                	addi	s2,s2,1
 22a:	fd879ce3          	bne	a5,s8,202 <gets+0x2e>
    buf[i++] = c;
 22e:	8d4e                	mv	s10,s3
 230:	a011                	j	234 <gets+0x60>
 232:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 234:	9d66                	add	s10,s10,s9
 236:	000d0023          	sb	zero,0(s10)
  return buf;
}
 23a:	8566                	mv	a0,s9
 23c:	70a6                	ld	ra,104(sp)
 23e:	7406                	ld	s0,96(sp)
 240:	64e6                	ld	s1,88(sp)
 242:	6946                	ld	s2,80(sp)
 244:	69a6                	ld	s3,72(sp)
 246:	6a06                	ld	s4,64(sp)
 248:	7ae2                	ld	s5,56(sp)
 24a:	7b42                	ld	s6,48(sp)
 24c:	7ba2                	ld	s7,40(sp)
 24e:	7c02                	ld	s8,32(sp)
 250:	6ce2                	ld	s9,24(sp)
 252:	6d42                	ld	s10,16(sp)
 254:	6165                	addi	sp,sp,112
 256:	8082                	ret

0000000000000258 <stat>:

int
stat(const char *n, struct stat *st)
{
 258:	1101                	addi	sp,sp,-32
 25a:	ec06                	sd	ra,24(sp)
 25c:	e822                	sd	s0,16(sp)
 25e:	e04a                	sd	s2,0(sp)
 260:	1000                	addi	s0,sp,32
 262:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 264:	4581                	li	a1,0
 266:	16e000ef          	jal	3d4 <open>
  if(fd < 0)
 26a:	02054263          	bltz	a0,28e <stat+0x36>
 26e:	e426                	sd	s1,8(sp)
 270:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 272:	85ca                	mv	a1,s2
 274:	178000ef          	jal	3ec <fstat>
 278:	892a                	mv	s2,a0
  close(fd);
 27a:	8526                	mv	a0,s1
 27c:	140000ef          	jal	3bc <close>
  return r;
 280:	64a2                	ld	s1,8(sp)
}
 282:	854a                	mv	a0,s2
 284:	60e2                	ld	ra,24(sp)
 286:	6442                	ld	s0,16(sp)
 288:	6902                	ld	s2,0(sp)
 28a:	6105                	addi	sp,sp,32
 28c:	8082                	ret
    return -1;
 28e:	597d                	li	s2,-1
 290:	bfcd                	j	282 <stat+0x2a>

0000000000000292 <atoi>:

int
atoi(const char *s)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29a:	00054683          	lbu	a3,0(a0)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	4625                	li	a2,9
 2a8:	02f66963          	bltu	a2,a5,2da <atoi+0x48>
 2ac:	872a                	mv	a4,a0
  n = 0;
 2ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b0:	0705                	addi	a4,a4,1
 2b2:	0025179b          	slliw	a5,a0,0x2
 2b6:	9fa9                	addw	a5,a5,a0
 2b8:	0017979b          	slliw	a5,a5,0x1
 2bc:	9fb5                	addw	a5,a5,a3
 2be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c2:	00074683          	lbu	a3,0(a4)
 2c6:	fd06879b          	addiw	a5,a3,-48
 2ca:	0ff7f793          	zext.b	a5,a5
 2ce:	fef671e3          	bgeu	a2,a5,2b0 <atoi+0x1e>
  return n;
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfdd                	j	2d2 <atoi+0x40>

00000000000002de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57563          	bgeu	a0,a1,310 <memmove+0x32>
    while(n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x2a>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    dst += n;
 310:	00c50733          	add	a4,a0,a2
    src += n;
 314:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 316:	fec059e3          	blez	a2,308 <memmove+0x2a>
 31a:	fff6079b          	addiw	a5,a2,-1
 31e:	1782                	slli	a5,a5,0x20
 320:	9381                	srli	a5,a5,0x20
 322:	fff7c793          	not	a5,a5
 326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 328:	15fd                	addi	a1,a1,-1
 32a:	177d                	addi	a4,a4,-1
 32c:	0005c683          	lbu	a3,0(a1)
 330:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 334:	fef71ae3          	bne	a4,a5,328 <memmove+0x4a>
 338:	bfc1                	j	308 <memmove+0x2a>

000000000000033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 342:	ca0d                	beqz	a2,374 <memcmp+0x3a>
 344:	fff6069b          	addiw	a3,a2,-1
 348:	1682                	slli	a3,a3,0x20
 34a:	9281                	srli	a3,a3,0x20
 34c:	0685                	addi	a3,a3,1
 34e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 350:	00054783          	lbu	a5,0(a0)
 354:	0005c703          	lbu	a4,0(a1)
 358:	00e79863          	bne	a5,a4,368 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 35c:	0505                	addi	a0,a0,1
    p2++;
 35e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 360:	fed518e3          	bne	a0,a3,350 <memcmp+0x16>
  }
  return 0;
 364:	4501                	li	a0,0
 366:	a019                	j	36c <memcmp+0x32>
      return *p1 - *p2;
 368:	40e7853b          	subw	a0,a5,a4
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret
  return 0;
 374:	4501                	li	a0,0
 376:	bfdd                	j	36c <memcmp+0x32>

0000000000000378 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 380:	f5fff0ef          	jal	2de <memmove>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38c:	4885                	li	a7,1
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <exit>:
.global exit
exit:
 li a7, SYS_exit
 394:	4889                	li	a7,2
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <wait>:
.global wait
wait:
 li a7, SYS_wait
 39c:	488d                	li	a7,3
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a4:	4891                	li	a7,4
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <read>:
.global read
read:
 li a7, SYS_read
 3ac:	4895                	li	a7,5
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <write>:
.global write
write:
 li a7, SYS_write
 3b4:	48c1                	li	a7,16
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <close>:
.global close
close:
 li a7, SYS_close
 3bc:	48d5                	li	a7,21
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c4:	4899                	li	a7,6
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3cc:	489d                	li	a7,7
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <open>:
.global open
open:
 li a7, SYS_open
 3d4:	48bd                	li	a7,15
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3dc:	48c5                	li	a7,17
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e4:	48c9                	li	a7,18
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ec:	48a1                	li	a7,8
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <link>:
.global link
link:
 li a7, SYS_link
 3f4:	48cd                	li	a7,19
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fc:	48d1                	li	a7,20
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 404:	48a5                	li	a7,9
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <dup>:
.global dup
dup:
 li a7, SYS_dup
 40c:	48a9                	li	a7,10
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 414:	48ad                	li	a7,11
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41c:	48b1                	li	a7,12
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 424:	48b5                	li	a7,13
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42c:	48b9                	li	a7,14
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 434:	1101                	addi	sp,sp,-32
 436:	ec06                	sd	ra,24(sp)
 438:	e822                	sd	s0,16(sp)
 43a:	1000                	addi	s0,sp,32
 43c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 440:	4605                	li	a2,1
 442:	fef40593          	addi	a1,s0,-17
 446:	f6fff0ef          	jal	3b4 <write>
}
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	6105                	addi	sp,sp,32
 450:	8082                	ret

0000000000000452 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 452:	7139                	addi	sp,sp,-64
 454:	fc06                	sd	ra,56(sp)
 456:	f822                	sd	s0,48(sp)
 458:	f426                	sd	s1,40(sp)
 45a:	f04a                	sd	s2,32(sp)
 45c:	ec4e                	sd	s3,24(sp)
 45e:	0080                	addi	s0,sp,64
 460:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 462:	c299                	beqz	a3,468 <printint+0x16>
 464:	0605ce63          	bltz	a1,4e0 <printint+0x8e>
  neg = 0;
 468:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 46a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 46e:	869a                	mv	a3,t1
  i = 0;
 470:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 472:	00000817          	auipc	a6,0x0
 476:	53e80813          	addi	a6,a6,1342 # 9b0 <digits>
 47a:	88be                	mv	a7,a5
 47c:	0017851b          	addiw	a0,a5,1
 480:	87aa                	mv	a5,a0
 482:	02c5f73b          	remuw	a4,a1,a2
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	9742                	add	a4,a4,a6
 48c:	00074703          	lbu	a4,0(a4)
 490:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 494:	872e                	mv	a4,a1
 496:	02c5d5bb          	divuw	a1,a1,a2
 49a:	0685                	addi	a3,a3,1
 49c:	fcc77fe3          	bgeu	a4,a2,47a <printint+0x28>
  if(neg)
 4a0:	000e0c63          	beqz	t3,4b8 <printint+0x66>
    buf[i++] = '-';
 4a4:	fd050793          	addi	a5,a0,-48
 4a8:	00878533          	add	a0,a5,s0
 4ac:	02d00793          	li	a5,45
 4b0:	fef50823          	sb	a5,-16(a0)
 4b4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4b8:	fff7899b          	addiw	s3,a5,-1
 4bc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4c0:	fff4c583          	lbu	a1,-1(s1)
 4c4:	854a                	mv	a0,s2
 4c6:	f6fff0ef          	jal	434 <putc>
  while(--i >= 0)
 4ca:	39fd                	addiw	s3,s3,-1
 4cc:	14fd                	addi	s1,s1,-1
 4ce:	fe09d9e3          	bgez	s3,4c0 <printint+0x6e>
}
 4d2:	70e2                	ld	ra,56(sp)
 4d4:	7442                	ld	s0,48(sp)
 4d6:	74a2                	ld	s1,40(sp)
 4d8:	7902                	ld	s2,32(sp)
 4da:	69e2                	ld	s3,24(sp)
 4dc:	6121                	addi	sp,sp,64
 4de:	8082                	ret
    x = -xx;
 4e0:	40b005bb          	negw	a1,a1
    neg = 1;
 4e4:	4e05                	li	t3,1
    x = -xx;
 4e6:	b751                	j	46a <printint+0x18>

00000000000004e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e8:	711d                	addi	sp,sp,-96
 4ea:	ec86                	sd	ra,88(sp)
 4ec:	e8a2                	sd	s0,80(sp)
 4ee:	e4a6                	sd	s1,72(sp)
 4f0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f2:	0005c483          	lbu	s1,0(a1)
 4f6:	28048463          	beqz	s1,77e <vprintf+0x296>
 4fa:	e0ca                	sd	s2,64(sp)
 4fc:	fc4e                	sd	s3,56(sp)
 4fe:	f852                	sd	s4,48(sp)
 500:	f456                	sd	s5,40(sp)
 502:	f05a                	sd	s6,32(sp)
 504:	ec5e                	sd	s7,24(sp)
 506:	e862                	sd	s8,16(sp)
 508:	e466                	sd	s9,8(sp)
 50a:	8b2a                	mv	s6,a0
 50c:	8a2e                	mv	s4,a1
 50e:	8bb2                	mv	s7,a2
  state = 0;
 510:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 512:	4901                	li	s2,0
 514:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 516:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 51a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 51e:	06c00c93          	li	s9,108
 522:	a00d                	j	544 <vprintf+0x5c>
        putc(fd, c0);
 524:	85a6                	mv	a1,s1
 526:	855a                	mv	a0,s6
 528:	f0dff0ef          	jal	434 <putc>
 52c:	a019                	j	532 <vprintf+0x4a>
    } else if(state == '%'){
 52e:	03598363          	beq	s3,s5,554 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 532:	0019079b          	addiw	a5,s2,1
 536:	893e                	mv	s2,a5
 538:	873e                	mv	a4,a5
 53a:	97d2                	add	a5,a5,s4
 53c:	0007c483          	lbu	s1,0(a5)
 540:	22048763          	beqz	s1,76e <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 544:	0004879b          	sext.w	a5,s1
    if(state == 0){
 548:	fe0993e3          	bnez	s3,52e <vprintf+0x46>
      if(c0 == '%'){
 54c:	fd579ce3          	bne	a5,s5,524 <vprintf+0x3c>
        state = '%';
 550:	89be                	mv	s3,a5
 552:	b7c5                	j	532 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 554:	00ea06b3          	add	a3,s4,a4
 558:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 55c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 55e:	c681                	beqz	a3,566 <vprintf+0x7e>
 560:	9752                	add	a4,a4,s4
 562:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 566:	05878263          	beq	a5,s8,5aa <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 56a:	05978c63          	beq	a5,s9,5c2 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 56e:	07500713          	li	a4,117
 572:	0ee78663          	beq	a5,a4,65e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 576:	07800713          	li	a4,120
 57a:	12e78863          	beq	a5,a4,6aa <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 57e:	07000713          	li	a4,112
 582:	14e78d63          	beq	a5,a4,6dc <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 586:	07300713          	li	a4,115
 58a:	18e78c63          	beq	a5,a4,722 <vprintf+0x23a>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == 'c'){
 58e:	06300713          	li	a4,99
 592:	1ce78163          	beq	a5,a4,754 <vprintf+0x26c>
        putc(fd, va_arg(ap, int));
      } else if(c0 == '%'){
 596:	02500713          	li	a4,37
 59a:	04e79463          	bne	a5,a4,5e2 <vprintf+0xfa>
        putc(fd, '%');
 59e:	85ba                	mv	a1,a4
 5a0:	855a                	mv	a0,s6
 5a2:	e93ff0ef          	jal	434 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b769                	j	532 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5aa:	008b8493          	addi	s1,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e9bff0ef          	jal	452 <printint>
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bf8d                	j	532 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5c2:	06400793          	li	a5,100
 5c6:	02f68963          	beq	a3,a5,5f8 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ca:	06c00793          	li	a5,108
 5ce:	04f68263          	beq	a3,a5,612 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5d2:	07500793          	li	a5,117
 5d6:	0af68063          	beq	a3,a5,676 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5da:	07800793          	li	a5,120
 5de:	0ef68263          	beq	a3,a5,6c2 <vprintf+0x1da>
        putc(fd, '%');
 5e2:	02500593          	li	a1,37
 5e6:	855a                	mv	a0,s6
 5e8:	e4dff0ef          	jal	434 <putc>
        putc(fd, c0);
 5ec:	85a6                	mv	a1,s1
 5ee:	855a                	mv	a0,s6
 5f0:	e45ff0ef          	jal	434 <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bf35                	j	532 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e4dff0ef          	jal	452 <printint>
        i += 1;
 60a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
        i += 1;
 610:	b70d                	j	532 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 612:	06400793          	li	a5,100
 616:	02f60763          	beq	a2,a5,644 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 61a:	07500793          	li	a5,117
 61e:	06f60963          	beq	a2,a5,690 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 622:	07800793          	li	a5,120
 626:	faf61ee3          	bne	a2,a5,5e2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4681                	li	a3,0
 630:	4641                	li	a2,16
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	e1bff0ef          	jal	452 <printint>
        i += 2;
 63c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	bdc5                	j	532 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	008b8493          	addi	s1,s7,8
 648:	4685                	li	a3,1
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	e01ff0ef          	jal	452 <printint>
        i += 2;
 656:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
        i += 2;
 65c:	bdd9                	j	532 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	de7ff0ef          	jal	452 <printint>
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	bd7d                	j	532 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	008b8493          	addi	s1,s7,8
 67a:	4681                	li	a3,0
 67c:	4629                	li	a2,10
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	dcfff0ef          	jal	452 <printint>
        i += 1;
 688:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
        i += 1;
 68e:	b555                	j	532 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4629                	li	a2,10
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	db5ff0ef          	jal	452 <printint>
        i += 2;
 6a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
        i += 2;
 6a8:	b569                	j	532 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4641                	li	a2,16
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	d9bff0ef          	jal	452 <printint>
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bd8d                	j	532 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	008b8493          	addi	s1,s7,8
 6c6:	4681                	li	a3,0
 6c8:	4641                	li	a2,16
 6ca:	000ba583          	lw	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	d83ff0ef          	jal	452 <printint>
        i += 1;
 6d4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	8ba6                	mv	s7,s1
      state = 0;
 6d8:	4981                	li	s3,0
        i += 1;
 6da:	bda1                	j	532 <vprintf+0x4a>
 6dc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6de:	008b8d13          	addi	s10,s7,8
 6e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e6:	03000593          	li	a1,48
 6ea:	855a                	mv	a0,s6
 6ec:	d49ff0ef          	jal	434 <putc>
  putc(fd, 'x');
 6f0:	07800593          	li	a1,120
 6f4:	855a                	mv	a0,s6
 6f6:	d3fff0ef          	jal	434 <putc>
 6fa:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fc:	00000b97          	auipc	s7,0x0
 700:	2b4b8b93          	addi	s7,s7,692 # 9b0 <digits>
 704:	03c9d793          	srli	a5,s3,0x3c
 708:	97de                	add	a5,a5,s7
 70a:	0007c583          	lbu	a1,0(a5)
 70e:	855a                	mv	a0,s6
 710:	d25ff0ef          	jal	434 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 714:	0992                	slli	s3,s3,0x4
 716:	34fd                	addiw	s1,s1,-1
 718:	f4f5                	bnez	s1,704 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 71a:	8bea                	mv	s7,s10
      state = 0;
 71c:	4981                	li	s3,0
 71e:	6d02                	ld	s10,0(sp)
 720:	bd09                	j	532 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 722:	008b8993          	addi	s3,s7,8
 726:	000bb483          	ld	s1,0(s7)
 72a:	cc91                	beqz	s1,746 <vprintf+0x25e>
        for(; *s; s++)
 72c:	0004c583          	lbu	a1,0(s1)
 730:	cd85                	beqz	a1,768 <vprintf+0x280>
          putc(fd, *s);
 732:	855a                	mv	a0,s6
 734:	d01ff0ef          	jal	434 <putc>
        for(; *s; s++)
 738:	0485                	addi	s1,s1,1
 73a:	0004c583          	lbu	a1,0(s1)
 73e:	f9f5                	bnez	a1,732 <vprintf+0x24a>
        if((s = va_arg(ap, char*)) == 0)
 740:	8bce                	mv	s7,s3
      state = 0;
 742:	4981                	li	s3,0
 744:	b3fd                	j	532 <vprintf+0x4a>
          s = "(null)";
 746:	00000497          	auipc	s1,0x0
 74a:	26248493          	addi	s1,s1,610 # 9a8 <malloc+0x13e>
        for(; *s; s++)
 74e:	02800593          	li	a1,40
 752:	b7c5                	j	732 <vprintf+0x24a>
        putc(fd, va_arg(ap, int));
 754:	008b8493          	addi	s1,s7,8
 758:	000bc583          	lbu	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	cd7ff0ef          	jal	434 <putc>
 762:	8ba6                	mv	s7,s1
      state = 0;
 764:	4981                	li	s3,0
 766:	b3f1                	j	532 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 768:	8bce                	mv	s7,s3
      state = 0;
 76a:	4981                	li	s3,0
 76c:	b3d9                	j	532 <vprintf+0x4a>
 76e:	6906                	ld	s2,64(sp)
 770:	79e2                	ld	s3,56(sp)
 772:	7a42                	ld	s4,48(sp)
 774:	7aa2                	ld	s5,40(sp)
 776:	7b02                	ld	s6,32(sp)
 778:	6be2                	ld	s7,24(sp)
 77a:	6c42                	ld	s8,16(sp)
 77c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 77e:	60e6                	ld	ra,88(sp)
 780:	6446                	ld	s0,80(sp)
 782:	64a6                	ld	s1,72(sp)
 784:	6125                	addi	sp,sp,96
 786:	8082                	ret

0000000000000788 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 788:	715d                	addi	sp,sp,-80
 78a:	ec06                	sd	ra,24(sp)
 78c:	e822                	sd	s0,16(sp)
 78e:	1000                	addi	s0,sp,32
 790:	e010                	sd	a2,0(s0)
 792:	e414                	sd	a3,8(s0)
 794:	e818                	sd	a4,16(s0)
 796:	ec1c                	sd	a5,24(s0)
 798:	03043023          	sd	a6,32(s0)
 79c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a0:	8622                	mv	a2,s0
 7a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a6:	d43ff0ef          	jal	4e8 <vprintf>
  va_end(ap);
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6161                	addi	sp,sp,80
 7b0:	8082                	ret

00000000000007b2 <printf>:

void
printf(const char *fmt, ...)
{
 7b2:	711d                	addi	sp,sp,-96
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	e40c                	sd	a1,8(s0)
 7bc:	e810                	sd	a2,16(s0)
 7be:	ec14                	sd	a3,24(s0)
 7c0:	f018                	sd	a4,32(s0)
 7c2:	f41c                	sd	a5,40(s0)
 7c4:	03043823          	sd	a6,48(s0)
 7c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	00840613          	addi	a2,s0,8
 7d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d4:	85aa                	mv	a1,a0
 7d6:	4505                	li	a0,1
 7d8:	d11ff0ef          	jal	4e8 <vprintf>
  va_end(ap);
}
 7dc:	60e2                	ld	ra,24(sp)
 7de:	6442                	ld	s0,16(sp)
 7e0:	6125                	addi	sp,sp,96
 7e2:	8082                	ret

00000000000007e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e4:	1141                	addi	sp,sp,-16
 7e6:	e406                	sd	ra,8(sp)
 7e8:	e022                	sd	s0,0(sp)
 7ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	00001797          	auipc	a5,0x1
 7f4:	8107b783          	ld	a5,-2032(a5) # 1000 <freep>
 7f8:	a02d                	j	822 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fa:	4618                	lw	a4,8(a2)
 7fc:	9f2d                	addw	a4,a4,a1
 7fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	6310                	ld	a2,0(a4)
 806:	a83d                	j	844 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 808:	ff852703          	lw	a4,-8(a0)
 80c:	9f31                	addw	a4,a4,a2
 80e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 810:	ff053683          	ld	a3,-16(a0)
 814:	a091                	j	858 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 816:	6398                	ld	a4,0(a5)
 818:	00e7e463          	bltu	a5,a4,820 <free+0x3c>
 81c:	00e6ea63          	bltu	a3,a4,830 <free+0x4c>
{
 820:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	fed7fae3          	bgeu	a5,a3,816 <free+0x32>
 826:	6398                	ld	a4,0(a5)
 828:	00e6e463          	bltu	a3,a4,830 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82c:	fee7eae3          	bltu	a5,a4,820 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 830:	ff852583          	lw	a1,-8(a0)
 834:	6390                	ld	a2,0(a5)
 836:	02059813          	slli	a6,a1,0x20
 83a:	01c85713          	srli	a4,a6,0x1c
 83e:	9736                	add	a4,a4,a3
 840:	fae60de3          	beq	a2,a4,7fa <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 844:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 848:	4790                	lw	a2,8(a5)
 84a:	02061593          	slli	a1,a2,0x20
 84e:	01c5d713          	srli	a4,a1,0x1c
 852:	973e                	add	a4,a4,a5
 854:	fae68ae3          	beq	a3,a4,808 <free+0x24>
    p->s.ptr = bp->s.ptr;
 858:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85a:	00000717          	auipc	a4,0x0
 85e:	7af73323          	sd	a5,1958(a4) # 1000 <freep>
}
 862:	60a2                	ld	ra,8(sp)
 864:	6402                	ld	s0,0(sp)
 866:	0141                	addi	sp,sp,16
 868:	8082                	ret

000000000000086a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86a:	7139                	addi	sp,sp,-64
 86c:	fc06                	sd	ra,56(sp)
 86e:	f822                	sd	s0,48(sp)
 870:	f04a                	sd	s2,32(sp)
 872:	ec4e                	sd	s3,24(sp)
 874:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 876:	02051993          	slli	s3,a0,0x20
 87a:	0209d993          	srli	s3,s3,0x20
 87e:	09bd                	addi	s3,s3,15
 880:	0049d993          	srli	s3,s3,0x4
 884:	2985                	addiw	s3,s3,1
 886:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 888:	00000517          	auipc	a0,0x0
 88c:	77853503          	ld	a0,1912(a0) # 1000 <freep>
 890:	c905                	beqz	a0,8c0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	09377663          	bgeu	a4,s3,922 <malloc+0xb8>
 89a:	f426                	sd	s1,40(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a2:	8a4e                	mv	s4,s3
 8a4:	6705                	lui	a4,0x1
 8a6:	00e9f363          	bgeu	s3,a4,8ac <malloc+0x42>
 8aa:	6a05                	lui	s4,0x1
 8ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b4:	00000497          	auipc	s1,0x0
 8b8:	74c48493          	addi	s1,s1,1868 # 1000 <freep>
  if(p == (char*)-1)
 8bc:	5afd                	li	s5,-1
 8be:	a83d                	j	8fc <malloc+0x92>
 8c0:	f426                	sd	s1,40(sp)
 8c2:	e852                	sd	s4,16(sp)
 8c4:	e456                	sd	s5,8(sp)
 8c6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c8:	00001797          	auipc	a5,0x1
 8cc:	94878793          	addi	a5,a5,-1720 # 1210 <base>
 8d0:	00000717          	auipc	a4,0x0
 8d4:	72f73823          	sd	a5,1840(a4) # 1000 <freep>
 8d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8de:	b7d1                	j	8a2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8e0:	6398                	ld	a4,0(a5)
 8e2:	e118                	sd	a4,0(a0)
 8e4:	a899                	j	93a <malloc+0xd0>
  hp->s.size = nu;
 8e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ea:	0541                	addi	a0,a0,16
 8ec:	ef9ff0ef          	jal	7e4 <free>
  return freep;
 8f0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8f2:	c125                	beqz	a0,952 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f6:	4798                	lw	a4,8(a5)
 8f8:	03277163          	bgeu	a4,s2,91a <malloc+0xb0>
    if(p == freep)
 8fc:	6098                	ld	a4,0(s1)
 8fe:	853e                	mv	a0,a5
 900:	fef71ae3          	bne	a4,a5,8f4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 904:	8552                	mv	a0,s4
 906:	b17ff0ef          	jal	41c <sbrk>
  if(p == (char*)-1)
 90a:	fd551ee3          	bne	a0,s5,8e6 <malloc+0x7c>
        return 0;
 90e:	4501                	li	a0,0
 910:	74a2                	ld	s1,40(sp)
 912:	6a42                	ld	s4,16(sp)
 914:	6aa2                	ld	s5,8(sp)
 916:	6b02                	ld	s6,0(sp)
 918:	a03d                	j	946 <malloc+0xdc>
 91a:	74a2                	ld	s1,40(sp)
 91c:	6a42                	ld	s4,16(sp)
 91e:	6aa2                	ld	s5,8(sp)
 920:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 922:	fae90fe3          	beq	s2,a4,8e0 <malloc+0x76>
        p->s.size -= nunits;
 926:	4137073b          	subw	a4,a4,s3
 92a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92c:	02071693          	slli	a3,a4,0x20
 930:	01c6d713          	srli	a4,a3,0x1c
 934:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 936:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93a:	00000717          	auipc	a4,0x0
 93e:	6ca73323          	sd	a0,1734(a4) # 1000 <freep>
      return (void*)(p + 1);
 942:	01078513          	addi	a0,a5,16
  }
}
 946:	70e2                	ld	ra,56(sp)
 948:	7442                	ld	s0,48(sp)
 94a:	7902                	ld	s2,32(sp)
 94c:	69e2                	ld	s3,24(sp)
 94e:	6121                	addi	sp,sp,64
 950:	8082                	ret
 952:	74a2                	ld	s1,40(sp)
 954:	6a42                	ld	s4,16(sp)
 956:	6aa2                	ld	s5,8(sp)
 958:	6b02                	ld	s6,0(sp)
 95a:	b7f5                	j	946 <malloc+0xdc>
