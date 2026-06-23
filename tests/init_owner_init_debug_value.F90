! (C) Copyright 2022- ECMWF.
! (C) Copyright 2022- Meteo-France.
!
! This software is licensed under the terms of the Apache Licence Version 2.0
! which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
! In applying this licence, ECMWF does not waive the privileges and immunities
! granted to it by virtue of its status as an intergovernmental organisation
! nor does it submit to any jurisdiction.

PROGRAM INIT_OWNER_INIT_DEBUG_VALUE
        !TEST THAT ALL DATA ARE INITIALIZE TO THE DEBUG VALUE CHOOSED BY THE
        !USER
        USE FIELD_MODULE
        USE FIELD_FACTORY_MODULE
        USE FIELD_DEFAULTS_MODULE
        USE PARKIND1
        USE OMP_LIB, ONLY: OMP_GET_MAX_THREADS
        USE FIELD_ABORT_MODULE
        IMPLICIT NONE
        CLASS(FIELD_2IM), POINTER :: OIM => NULL()
        CLASS(FIELD_2RM), POINTER :: ORM => NULL()
        CLASS(FIELD_2RD), POINTER :: ORD => NULL()
        CLASS(FIELD_2RB), POINTER :: ORB => NULL()
        INTEGER(KIND=JPIM), POINTER :: PTRIM(:,:)
        REAL(KIND=JPRM), POINTER :: PTRRM(:,:)
        REAL(KIND=JPRD), POINTER :: PTRRD(:,:)
        !REAL(KIND=JPRB), POINTER :: PTRRB(:,:)

        USE_INIT_DEBUG_VALUE = .TRUE.

        INIT_DEBUG_VALUE_JPIM=-123456789
        CALL FIELD_NEW(OIM, LBOUNDS=[1,1], UBOUNDS=[10,10])
        CALL OIM%GET_HOST_DATA_RDWR(PTRIM)
        IF (.NOT. ALL(OIM%PTR == -123456789)) THEN
                CALL FIELD_ABORT ("WRONG DEFAULT VALUE FOR JPIM")
        END IF
        CALL FIELD_DELETE(OIM)

        INIT_DEBUG_VALUE_JPRM=100
        CALL FIELD_NEW(ORM, LBOUNDS=[1,1], UBOUNDS=[10,10])
        CALL ORM%GET_HOST_DATA_RDWR(PTRRM)
        IF (.NOT. ALL(ORM%PTR == 100)) THEN
                CALL FIELD_ABORT ("WRONG DEFAULT VALUE FOR JPRM")
        END IF
        CALL FIELD_DELETE(ORM)

        INIT_DEBUG_VALUE_JPRD=100
        CALL FIELD_NEW(ORD, LBOUNDS=[1,1], UBOUNDS=[10,10])
        CALL ORD%GET_HOST_DATA_RDWR(PTRRD)
        IF (.NOT. ALL(ORD%PTR == 100)) THEN
                CALL FIELD_ABORT ("WRONG DEFAULT VALUE FOR JPRD")
        END IF
        CALL FIELD_DELETE(ORD)

        !INIT_DEBUG_VALUE_JPRB=100
        !CALL FIELD_NEW(ORB, LBOUNDS=[1,1], UBOUNDS=[10,10])
        !CALL ORB%GET_HOST_DATA_RDWR(PTRRB)
        !IF (.NOT. ALL(ORB%PTR == 100)) THEN
        !        CALL FIELD_ABORT ("WRONG DEFAULT VALUE FOR JPRB")
        !END IF
        !CALL FIELD_DELETE(ORB)

END PROGRAM INIT_OWNER_INIT_DEBUG_VALUE
