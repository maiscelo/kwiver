/*ckwg +29
 * Copyright 2015-2017 by Kitware, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither name of Kitware, Inc. nor the names of any contributors may be used
 *    to endorse or promote products derived from this software without specific
 *    prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * \file
 * \brief Frame to World Homography definition
 */

#ifndef VITAL_HOMOGRAPHY_F2W_H
#define VITAL_HOMOGRAPHY_F2W_H

#include <vital/types/homography.h>
#include <vital/types/timestamp.h>

namespace kwiver {
namespace vital {


class VITAL_EXPORT homography_f2w
{
public:
  /// Construct an identity homography for the given frame
  homography_f2w( const timestamp& frame_id );

  /// Construct given an existing homography
  /**
   * The given homography sptr is cloned into this object so we retain a unique
   * copy.
   */
  homography_f2w( homography_sptr const &h, const timestamp& frame_id );

  /// Copy Constructor
  homography_f2w( homography_f2w const &h );

  virtual ~homography_f2w() VITAL_DEFAULT_DTOR

  /// Get the homography transformation
  virtual homography_sptr homography() const;

  /// Get the frame identifier
  virtual const timestamp& frame_id() const;

protected:
  /// Homography transformation
  homography_sptr h_;

  /// Frame identifier
  timestamp frame_id_;
};


} } // end vital namespace


#endif // VITAL_HOMOGRAPHY_F2W_H
